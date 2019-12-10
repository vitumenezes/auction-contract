pragma solidity 0.4.25;

contract Leilao {

    // total number of itens already added
    uint count_item;

    // available items count
    uint count_itens_disponiveis;

    /*
    * @dev Emitted when a new item is added
    **/
    event ItemAdicionado(string titulo, string descricao, uint valor_inicial, uint diferenca_minima, uint data_expiracao);

    /*
    * @dev Emitted when a new bid is added to a item
    **/
    event LanceAdicionado(address bidder, uint num_item, uint valor_lance);

    /*
    * @dev Emitted when an auction is finished
    **/
    event LeilaoFinalizado(uint num_item, address vencedor);

    /*
    * @dev Emitted when a token transfer is made
    **/
    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);

    /*
    * @dev Emitted when a token transfer approval is made
    **/
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);



    struct Item {
        address dono_lance_atual; // Endereco que esta vencendo o leilao
        address dono; // Endereco que adicionou o item para leilao

        string titulo; // Titulo do item
        string descricao; // Descricao do item

        uint token; // Token do item (contagem de itens)
        uint valor_inicial; // Valor inicial (base) do item
        uint lance_atual; // Valor atual do item
        uint diferenca_minima; // Diferenca minima entre lances
        uint data_expiracao; // Duração do item no leilão
    }

    /*
    * @dev Modifier to make a function callable only when the sender is the token owner
    **/
    modifier onlyOwnerOfToken (address _from, uint256 _tokenId) {
        require(_from == _tokenOwner[_tokenId]);
        _;
    }

    /*
    * @dev Modifier to make a function callable only when the sender is the item owner
    **/
    modifier onlyOwnerOfItem(uint256 _item) {
        require(msg.sender == itens[_item].dono, "Você não pode finalizar um leilao do qual não é o dono.");
        _;
    }

    // Items mapping. Each item has one uint to represent it
    mapping (uint => Item) public itens;

    // Token balance on an account - ERC721
    mapping (address => uint256) public ownerTokenCount;

    // Relates the token with the owner - ERC721
    mapping (uint256 => address) internal _tokenOwner;

    // Token transfer approvals - ERC721
    mapping (uint256 => address) tokenApprovals;

    // Available itens to auction
    Item[] public itens_disponiveis;


    /*
    * @dev Public function to add a new item to auctioned.
    *
    * Emits an {ItemAdicionado} event.
    *
    * @param _titulo item title.
    * @param _descricao item description.
    * @param _valor_inicial initial value of item.
    * @param _diferenca_minima minimum difference between bids.
    * @param _qtd_dias number of days the item will be up for auction.
    **/
    function adicionar_item(string _titulo, string _descricao, uint _valor_inicial, uint _diferenca_minima, uint _qtd_dias) public {
        count_item++;
        count_itens_disponiveis++;

        Item memory novo_item = Item(0,
                                    msg.sender,
                                    _titulo,
                                    _descricao,
                                    count_item,
                                    _valor_inicial,
                                    _valor_inicial,
                                    _diferenca_minima,
                                    (now + _qtd_dias * 1 days));

        ownerTokenCount[this]++;
        _tokenOwner[novo_item.token] = this;
        itens[count_item] = novo_item;

        itens_disponiveis.push(novo_item);

        emit ItemAdicionado(novo_item.titulo, novo_item.descricao, novo_item.valor_inicial, novo_item.diferenca_minima, novo_item.data_expiracao);
    }


    /*
    * @dev Implementation of {ERC721} interface
    **/
    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerTokenCount[_owner];
    }

    /*
    * @dev Implementation of {ERC721} interface
    **/
    function _ownerOf(uint256 _tokenId) private view returns (address _owner) {
        return _tokenOwner[_tokenId];
    }

    /*
    * @dev Implementation of {ERC721} interface
    **/
    function transfer(address _to, uint256 _tokenId) public {
        _transfer(this, _to, _tokenId);
    }

    /*
    * @dev Implementation of {ERC721} interface
    **/
    function _transfer(address _from, address _to, uint256 _tokenId) private onlyOwnerOfToken(_from, _tokenId) {
        ownerTokenCount[_to]++;
        ownerTokenCount[_from]--;
        _tokenOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    /*
    * @dev Implementation of {ERC721} interface
    **/
    function approve(address _to, uint256 _tokenId) public onlyOwnerOfToken(msg.sender, _tokenId) {
        tokenApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    /*
    * @dev Implementation of {ERC721} interface
    **/
    function takeOwnership(uint256 _tokenId) public {
        require(tokenApprovals[_tokenId] == msg.sender);
        address owner = _ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }

    function dar_lance(uint _num_item) public payable {
        require(itens[_num_item].dono != 0, "Esse item não está disponível.");

        Item storage item_atual = itens[_num_item];

        require(now < (item_atual.data_expiracao), "Este item já expirou. Verique o ganhador.");
        require(msg.value >= item_atual.lance_atual + item_atual.diferenca_minima, "O valor não atingiu a diferença mínima.");
        require(msg.value > item_atual.lance_atual, "O valor não pode ser menor que o lance atual.");

        // Caso o item atual ja tenha recebido lance, reembolsar a pessoa que deu lance antes dele
        if(item_atual.dono_lance_atual != 0){
            _transferir(item_atual.dono_lance_atual, item_atual.lance_atual);
        }

        item_atual.dono_lance_atual = msg.sender;
        item_atual.lance_atual = msg.value;

        emit LanceAdicionado(item_atual.dono_lance_atual, _num_item, item_atual.lance_atual);
    }

    function ver_ganhador(uint _num_item) view public returns(address) {
        require(itens[_num_item].dono != 0, "Esse item não está mais disponível.");

        Item storage item_atual = itens[_num_item];

        if (now >= item_atual.data_expiracao) {
            _realizar_tramites(_num_item);
        } else if (item_atual.valor_inicial == item_atual.lance_atual) {
            return item_atual.dono;
        }

        return item_atual.dono_lance_atual;
    }

    function finalizar_leilao(uint256 _num_item) public onlyOwnerOfItem(_num_item) {
        Item storage item_atual = itens[_num_item];

        if (now <= (item_atual.data_expiracao)) {
            item_atual.data_expiracao = now;
        }

        _realizar_tramites(_num_item);

        emit LeilaoFinalizado(_num_item, item_atual.dono_lance_atual);
    }

    function _realizar_tramites(uint256 _num_item) private {
        Item storage item_atual = itens[_num_item];

        if (item_atual.dono_lance_atual != 0) {
            _transferir(item_atual.dono, item_atual.lance_atual);
            transfer(item_atual.dono_lance_atual, item_atual.token);
        }

        delete itens[_num_item];
        for (uint i = 0; i < count_itens_disponiveis; i++) {
            if (itens_disponiveis[i].token == _num_item) {
                delete itens_disponiveis[i];
            }
        }
        count_itens_disponiveis--;

    }

    function _transferir(address _dono_lance_anterior, uint _valor) private {
        _dono_lance_anterior.transfer(_valor);
    }
}
