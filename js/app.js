var leilao;
var userAccount;
var actualAccount;

function startApp(){
    var contractAddress = '0x20f0FD75DC62967fB1D0E3e6cf0C9c21E79A1C00';

    var ok = document.getElementById("itens");

    leilao = new web3.eth.Contract(abi, contractAddress);

    var accountInterval = setInterval(function() {

        web3.eth.getAccounts().then(function (result) {
            actualAccount = result[0];
        })

        // Check if account has changed
        if (actualAccount !== userAccount) {
            userAccount = actualAccount;
            // Call some function to update the UI with the new account
            // $("#contractAddress").text("Your Account: " + userAccount);
            atualizarDados();
        }
    }, 100);
}

function dar_lance(id){
    var id = document.getElementById("item_id").value;
    var lance_atual = document.getElementById("item_lance_atual").value;
    var valor = 1000000000000000000*lance_atual;
    leilao.methods.dar_lance(id).send({ from: userAccount, value: valor });
    return false;
}

function mostrar_itens_disponiveis() {
    var ids = document.getElementById("item_id").value;
    $("#itens").empty();
    for (id of ids) {
    itens_disponiveis(id)
    .then((result) => {
        // Using ES6's "template literals" to inject variables into the HTML.
        const new_item = `
            <div class="zombie">
                <ul>
                    <li>Titulo: ${result.titulo}</li>
                    <li>Descrição: ${result.descricao}</li>
                    <li>Token: ${result.token}</li>
                </ul>
            </div>
        `;

        document.getElementById("itens").innerHTML = new_item;
    });
    }
}

function show_itens() {
    var table_tbody = document.getElementById("itens").getElementsByName('tbody')[0];
    var count_itens_disponiveis = leilao.methods.count_itens_disponiveis().call();

    table_tbody.empty();

    for (var i; i < count_itens_disponiveis; i++) {
        itens_disponiveis(i)
        .then((result) => {
            // Using ES6's "template literals" to inject variables into the HTML.
            const new_item = `
                <div class="item">
                    <ul>
                        <li>Titulo: ${result.titulo}</li>
                        <li>Descrição: ${result.descricao}</li>
                        <li>Token: ${result.token}</li>
                    </ul>
                </div>
            `;

            table_tbody.innerHTML = new_item;
        });
    }
}

function itens_disponiveis(id){
    return leilao.methods.itens_disponiveis(id).call();
}

function atualizarDados(){
    document.getElementById("contractAddress").innerHTML = "Your Account: " + userAccount;
}

function adicionar_item(){
    var titulo = document.getElementById("item_titulo").value;
    var descricao = document.getElementById("item_descricao").value;
    var valor_inicial = document.getElementById("item_valor_inicial").value;

    var valor_incremento = document.getElementById("item_valor_incremento").value;

    var data_expiracao = document.getElementById("item_data_expiracao").value;

    leilao.methods.adicionar_item(titulo, descricao, valor_inicial, valor_incremento, data_expiracao).send({ from: userAccount });
    return false;

}