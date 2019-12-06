var abi = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "_to",
				"type": "address"
			},
			{
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "approve",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"name": "itens",
		"outputs": [
			{
				"name": "dono_lance_atual",
				"type": "address"
			},
			{
				"name": "dono",
				"type": "address"
			},
			{
				"name": "titulo",
				"type": "string"
			},
			{
				"name": "descricao",
				"type": "string"
			},
			{
				"name": "token",
				"type": "uint256"
			},
			{
				"name": "valor_inicial",
				"type": "uint256"
			},
			{
				"name": "lance_atual",
				"type": "uint256"
			},
			{
				"name": "diferenca_minima",
				"type": "uint256"
			},
			{
				"name": "data_expiracao",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"name": "itens_disponiveis",
		"outputs": [
			{
				"name": "dono_lance_atual",
				"type": "address"
			},
			{
				"name": "dono",
				"type": "address"
			},
			{
				"name": "titulo",
				"type": "string"
			},
			{
				"name": "descricao",
				"type": "string"
			},
			{
				"name": "token",
				"type": "uint256"
			},
			{
				"name": "valor_inicial",
				"type": "uint256"
			},
			{
				"name": "lance_atual",
				"type": "uint256"
			},
			{
				"name": "diferenca_minima",
				"type": "uint256"
			},
			{
				"name": "data_expiracao",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_owner",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"name": "_balance",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_titulo",
				"type": "string"
			},
			{
				"name": "_descricao",
				"type": "string"
			},
			{
				"name": "_valor_inicial",
				"type": "uint256"
			},
			{
				"name": "_diferenca_minima",
				"type": "uint256"
			},
			{
				"name": "_qtd_dias",
				"type": "uint256"
			}
		],
		"name": "adicionar_item",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_num_item",
				"type": "uint256"
			}
		],
		"name": "ver_ganhador",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_to",
				"type": "address"
			},
			{
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "transfer",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_num_item",
				"type": "uint256"
			}
		],
		"name": "dar_lance",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "takeOwnership",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "ownerTokenCount",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_num_item",
				"type": "uint256"
			}
		],
		"name": "finalizar_leilao",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "titulo",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "descricao",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "valor_inicial",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "diferenca_minima",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "data_expiracao",
				"type": "uint256"
			}
		],
		"name": "ItemAdicionado",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "bidder",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "num_item",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "valor_lance",
				"type": "uint256"
			}
		],
		"name": "LanceAdicionado",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "num_item",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "vencedor",
				"type": "address"
			}
		],
		"name": "LeilaoFinalizado",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "_from",
				"type": "address"
			},
			{
				"indexed": true,
				"name": "_to",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "Transfer",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "_owner",
				"type": "address"
			},
			{
				"indexed": true,
				"name": "_approved",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "Approval",
		"type": "event"
	}
]