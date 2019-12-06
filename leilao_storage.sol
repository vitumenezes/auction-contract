pragma solidity 0.4.25;

contract LeilaoStorage {
    
    uint count_item;
    uint count_itens_disponiveis;

    event ItemAdicionado(string titulo, string descricao, uint valor_inicial, uint diferenca_minima, uint data_expiracao);

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

    modifier onlyOwnerOfToken (address _from, uint256 _tokenId) {
        require(_from == _tokenOwner[_tokenId]);
        _;
    }
    
    modifier onlyOwnerOfItem(uint256 _item) {
        require(msg.sender == itens[_item].dono, "Você não pode finalizar um leilao do qual não é o dono.");
        _;
    }

    mapping (uint => Item) public itens; // mapping de itens
    mapping (address => uint256) public ownerTokenCount; // Armazena o saldo de cada conta que possui tokens
    mapping (uint256 => address) internal _tokenOwner; // Relaciona o token com o dono
    
    Item[] public itens_disponiveis;

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
}
