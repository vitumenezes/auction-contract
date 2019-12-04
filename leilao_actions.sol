pragma solidity 0.4.25;
pragma experimental ABIEncoderV2;

import "./erc721.sol";
import "./leilao_storage.sol";

contract LeilaoActions is LeilaoStorage {
    
    function get_itens_leilao() view public returns(Item[]) {
        return itensAdicionados;
    }
    
    function dar_lance(uint _num_item) public payable {
        require(itens[_num_item].dono != 0, "Esse item não está mais disponível.");
        Item storage item_atual = itens[_num_item];
        
        require(now < item_atual.qtd_dias);
        
        require(msg.value > 0, "O valor não pode ser menor ou igual a zero.");
        require(msg.value > item_atual.lance_atual, "O valor não pode ser menor que o lance atual.");
        
        // Caso o item atual ja tenha recebido lance, reembolsar a pessoa que deu lance antes dele
        if(item_atual.dono_lance_atual != 0){
            transferir(item_atual.dono_lance_atual, item_atual.lance_atual);
        }
        
        item_atual.dono_lance_atual = msg.sender;
        item_atual.lance_atual = msg.value;
        
    }
    
    function get_ganhador(uint _num_item) view public returns(address) {
        require(itens[_num_item].dono != 0, "Esse item não está mais disponível.");
        Item storage item_atual = itens[_num_item];
        
        require(item_atual.valor_inicial != item_atual.lance_atual, "Este item não teve lances.");
        
        uint tempo_remanescente = now - item_atual.data_criacao;
        
        // uint256 t = item_atual.token.balanceOf(item_atual.dono);
        // Caso o item não tenha recebido lance, envia o token de volta pro dono do item
        if(item_atual.dono_lance_atual == 0){
            // item_atual.token.transfer(item_atual.dono, t);
            return item_atual.dono;
        }else{
            if(tempo_remanescente >= item_atual.qtd_dias){
                // Transfere o valor do lance pro criador do lance e envia o token para o ganhador do leilão
                transferir(item_atual.dono, item_atual.lance_atual);
                // item_atual.token.transfer(item_atual.dono_lance_atual, t);
                return item_atual.dono_lance_atual;
            }
        }
    }
    
    function transferir(address _dono_lance_anterior, uint _valor) private {
        _dono_lance_anterior.transfer(_valor);
    }
    
    
    
}
