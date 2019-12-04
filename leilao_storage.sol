pragma solidity 0.4.25;
pragma experimental ABIEncoderV2;

import "./leilao_token.sol";

contract LeilaoStorage is LeilaoToken {

    uint count_item;

    struct Item {
        address dono_lance_atual; // Endereco que esta vencendo o leilao
        address dono; // Endereco que adicionou o item para leilao

        string titulo; // Titulo do item
        string descricao; // Descricao do item
        
        uint token; // Token do item (contagem de itens)
        uint valor_inicial; // Valor inicial (base) do item
        uint lance_atual; //Valor atual do item
        uint data_criacao; //Data da criação quando é feito o deploy do contrato
        uint qtd_dias; // Duração do item no leilão
    }

    mapping(uint => Item) public itens;
    
    mapping (address => uint256) public ownerTokenCount; // Armazena o saldo de cada conta que possui tokens
    
    mapping (uint256 => address) private _tokenOwner; // Relaciona o token com o dono
    
    Item[] public itensAdicionados;
    
    function adicionar_item(string _titulo, string _descricao, uint _valor_inicial, uint _qtd_dias) public {
        count_item++;
        
        Item memory novo_item = Item(0, msg.sender, _titulo, _descricao, count_item,
                                    _valor_inicial, _valor_inicial, now, now + _qtd_dias);
        
        ownerTokenCount[this]++;
        _tokenOwner[novo_item.token] = this;
        itens[count_item] = novo_item;
        itensAdicionados.push(novo_item);
    }
}
