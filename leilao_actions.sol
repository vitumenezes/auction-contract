pragma solidity 0.4.25;
pragma experimental ABIEncoderV2;

import "./leilao_token.sol";

contract LeilaoActions is LeilaoToken {
    
    event LanceAdicionado(address bidder, uint num_item, uint valor_lance);
    event LeilaoFinalizado(uint num_item, address vencedor);
    
    
    function get_itens_leilao() view public returns(Item[]) {
        return itensAdicionados;
    }


    function dar_lance(uint _num_item) public payable {
        require(itens[_num_item].dono != 0, "Esse item não está disponível.");
        
        Item storage item_atual = itens[_num_item];

        require(now < (item_atual.data_expiracao), "Este item já expirou. Verique o ganhador.");
        require((msg.value * 1 ether) >= item_atual.lance_atual + item_atual.diferenca_minima, "O valor não atingiu a diferença mínima.");
        require((msg.value * 1 ether) > item_atual.lance_atual, "O valor não pode ser menor que o lance atual.");

        // Caso o item atual ja tenha recebido lance, reembolsar a pessoa que deu lance antes dele
        if(item_atual.dono_lance_atual != 0){
            _transferir(item_atual.dono_lance_atual, item_atual.lance_atual);
        }

        item_atual.dono_lance_atual = msg.sender;
        item_atual.lance_atual = msg.value * 1 ether;
        
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
        
        if (item_atual.dono_lance_atual == 0) {
            delete itens[_num_item];
        } else {
            _transferir(item_atual.dono, item_atual.lance_atual);
            transfer(item_atual.dono_lance_atual, item_atual.token);
            delete itens[_num_item];
        }
    }


    function _transferir(address _dono_lance_anterior, uint _valor) private {
        _dono_lance_anterior.transfer(_valor);
    }
}