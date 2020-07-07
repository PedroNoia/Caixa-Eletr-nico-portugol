programa
{

inclua biblioteca Arquivos --> a
inclua biblioteca Util --> util
inclua biblioteca Texto --> tx
inclua biblioteca Objetos --> o
inclua biblioteca Tipos --> t
inclua biblioteca Calendario --> c

cadeia idioma = "ptBr"
logico logado = falso
funcao inicio()
{
	enquanto(verdadeiro){
		escreval(" Escolha uma opção")
		escreval(" 1 - Acessar sua conta")
		escreval(" 2 - Criar uma conta")
		inteiro opcao
		leia(opcao)
		limpa()
		se(opcao == 1){
			acessarConta()
		}senao se(opcao == 2){
			criarConta()
		} senao {
			escreval("Opção invalida")
		}
	}
}
funcao acessarConta(){
	escreval("Digite o numero da sua conta e sua senha de 6 digitos")
	
	inteiro conta, senhaDigitada
	leia(conta, senhaDigitada)
	inteiro objConta = buscaConta(conta)

	se(objConta == -1){
		escreval("Conta não encontrada")
	} senao {
		//TODO validar senha
		logado = verdadeiro
		telaOperacaoBancaria(objConta)
		inteiro senhaReal = o.obter_propriedade_tipo_inteiro(objConta, "senha")
		//explicar
		se (senhaReal != senhaDigitada){
			limpa()
			escreval("Senha invalida")
		} senao {
			logado = verdadeiro
			telaOperacaoBancaria(objConta)
		}
	}
}
		
	funcao telaOperacaoBancaria(inteiro objConta){
	cadeia nome = o.obter_propriedade_tipo_cadeia(objConta, "nome")
	inteiro conta = o.obter_propriedade_tipo_inteiro(objConta, "conta")

	enquanto(logado){
		limpa()
		escreval("Olá " + nome)
		escreval(" Escolha uma opção: ")
		escreval(" 1 - Saldo")
		escreval(" 2 - Extrato")
		escreval(" 3 - Saque")
		escreval(" 4 - Deposito")
		escreval(" 5 - Sair")
		inteiro opcao
		leia(opcao)
		escolha(opcao){

			caso 1: 
				
				mostraSaldo(conta)
				enterParaContinuar()
				pare
			caso 2: 
				
				mostraExtrato(conta)
				enterParaContinuar()
				pare
			caso 3: 
				
				fazSaque(conta)
				enterParaContinuar()
				pare
			caso 4: 
				
				fazDeposito(conta)
				enterParaContinuar()
				pare
			caso 5: logado = falso
				pare
				
			caso contrario: 
				escreva(" Opção invalida ")
				pare
		}
	}
}	

funcao fazSaque(inteiro conta){
	escreval("Qual valor você deseja sacar?")
	real valor
	leia(valor)
	real saldo = consultaSaldo(conta)
	se (valor > saldo){
		limpa()
		escreval("Você não tem limite disponivel, seu saldo é: " + saldo )
	} senao {
		atualizaSaldo(conta, -1*valor)
		gravaExtrato(conta, " Saque no valor de " + valor)
		limpa()
		escreval("Deposito realizado com sucesso")
	}
}

funcao fazDeposito(inteiro conta){
	escreval("Qual valor você deseja depositar?")
	real valor
	leia(valor)
	atualizaSaldo(conta, valor)
	gravaExtrato(conta, " Depósitio no valor de " + valor)
	limpa()
	escreval("Depósitio realizado com sucesso")
}

funcao atualizaSaldo(inteiro conta, real valor){
	real saldoAtual = consultaSaldo(conta)
	real saldoNovo

	saldoNovo = saldoAtual + valor

	inteiro arq = a.abrir_arquivo("./arquivo/conta/1234_saldo.txt", a.MODO_ESCRITA)
	a.escrever_linha(valor + "", arq)
	a.fechar_arquivo(arq)

}

funcao gravaExtrato(inteiro conta, cadeia texto){
	cadeia data = obterData()
	real saldoAtual = consultaSaldo(conta)
	real saldoNovo

	inteiro arq = a.abrir_arquivo("./arquivo/conta/1234_extrato.txt", a.MODO_ACRESCENTAR)
	a.escrever_linha(data + " : " + texto, arq)
	a.fechar_arquivo(arq)
}

funcao mostraExtrato(inteiro conta){
	cadeia extrato = consultaExtrato(conta)
	limpa()
	mostraSaldo(conta)
	escreval("--------------")
	escreval("Extrato: ")
	escreval(extrato)
	escreval("--------------")
}

funcao cadeia consultaExtrato(inteiro conta){
	cadeia extrato = ""
	se(a.arquivo_existe("./arquivo/conta/" + conta + "_extrato.txt")){
		inteiro arq = a.abrir_arquivo("./arquivo/conta/1234_extrato.txt", a.MODO_LEITURA)
		enquanto (nao a.fim_arquivo(arq)){
			extrato = extrato + a.ler_linha(arq) + "\n"
		}	
		a.fechar_arquivo(arq)	
	} senao {
		//cria arquivo
		inteiro arq = a.abrir_arquivo("./arquivo/conta/1234_extrato.txt", a.MODO_ESCRITA)
		a.fechar_arquivo(arq)
	}

	se (extrato == "" ou extrato == "\n"){
		extrato = " Sem dados "
	}

	retorne extrato
}

funcao mostraSaldo(inteiro conta){
	real saldo = consultaSaldo(conta)
	limpa()
	escreval("--------------")
	escreval("Saldo: "+ saldo)
	escreval("")
	escreval("--------------")
}

funcao enterParaContinuar(){
	escreval("Aperte enter para continuar")
	cadeia algo
	leia(algo)
	limpa()
}

funcao real consultaSaldo(inteiro conta){
	cadeia saldo = "0"
	se(a.arquivo_existe("./arquivo/conta/" + conta + "_saldo.txt")){
		inteiro arq = a.abrir_arquivo("./arquivo/conta/1234_saldo.txt", a.MODO_LEITURA)
		saldo = a.ler_linha(arq)					
		a.fechar_arquivo(arq)	
	} senao {
		inteiro arq = a.abrir_arquivo("./arquivo/conta/1234_saldo.txt", a.MODO_ESCRITA)
		a.escrever_linha("0", arq)
		a.fechar_arquivo(arq)
	}

	retorne t.cadeia_para_real(saldo)
}
funcao inteiro buscaConta(inteiro conta){
	inteiro objConta = -1
	inteiro arq = a.abrir_arquivo("./arquivo/contas.txt", a.MODO_LEITURA)
	
	enquanto (nao a.fim_arquivo(arq)){
		cadeia linha = a.ler_linha(arq)					
		inteiro posicao = tx.posicao_texto("conta\" : " + conta, linha, 0)
		logico contaEncontrada = (posicao > 0)
		se(contaEncontrada){
			objConta = o.criar_objeto_via_json(linha)
			pare
		}
	}

	a.fechar_arquivo(arq)
	retorne objConta;
}

funcao criarConta(){
	cadeia opcao
	cadeia cpf
	cadeia dataNascimento
	cadeia nome
	inteiro senha
	
	escreval("Bem vindo ao Banco do Start Latam!")
	escreval("Você está criando uma conta, digite qualquer coisa para continuar")
	escreval("ou se já tem um conta digite SAIR para voltar a tela inicial!")
	leia(opcao)
	se (opcao == "SAIR" ou opcao == "sair"){
		retorne
	}
	escreval("informe seu cpf:")
	leia(cpf)
	//TODO validar cpf
	escreval("informe sua data de nascimento:")
	leia(dataNascimento)
	//TODO validar data de nascimento só para maiores de 18 anos
	escreval("informe seu nome:")
	leia(nome)
	//TODO Verificar se só tem letras
	//TODO repetir informações para confirmar se está ok
	limpa()
	senha = cadastraSenha()
	inteiro numDaConta = numeroDaConta()
	cadeia dadosDaConta = "{\"conta\" : " + numDaConta + ","
	dadosDaConta = dadosDaConta + " \"cpf\" : \"" + cpf  + "\","
	dadosDaConta += " \"dtNascimento\" : \"" + dataNascimento + "\","
	dadosDaConta += " \"nome\" : \"" + nome + "\",",
	dadosDaConta += " \"senha\" : " + senha + "}"
	escreverNoArquivo("./arquivo/contas.txt", dadosDaConta)
	
}
funcao escreverNoArquivo(cadeia arquivo, cadeia conteudo){
	inteiro arq = a.abrir_arquivo(arquivo, a.MODO_ACRESCENTAR)
	a.escrever_linha(conteudo, arq)
	a.fechar_arquivo(arq)
}
funcao inteiro numeroDaConta(){
	//TODO garantir que o numero da conta não seja repetido com uma conta que já existe
	retorne util.sorteia(1000, 9999)
	
}
funcao inteiro cadastraSenha(){
	logico senhaCadastraComSucesso = falso
	inteiro senha = 0
	inteiro confirmaSenha
	
	enquanto(nao senhaCadastraComSucesso){
		escreval("Digite uma senha com 6 numeros:")
		leia(senha)
		enquanto(nao senhaCom6Numeros(senha)){
			escreval("Senha invalida")
			escreval("digite uma senha com 6 numeros:")
			leia(senha)	
		}
		
		escreval("confirme sua senha")
		leia(confirmaSenha)
		se(senha == confirmaSenha){
			senhaCadastraComSucesso = verdadeiro
		} senao {
			limpa()
			escreval("senhas não conferem!")
		}
	}
	retorne senha
}
funcao logico senhaCom6Numeros(inteiro senha){
	logico senhaTem6Numero = (senha/100000 >= 1 e senha/100000 < 10)
	retorne senhaTem6Numero
}
funcao escreval(cadeia texto){
	//cadeia texto = lerArquivo(idioma, nomeMensagem)
	escreva(texto + "\n")
}
funcao cadeia obterData(){
	retorne 
		+ c.ano_atual() + "-"
		+ c.mes_atual() + "-"
		+ c.dia_mes_atual() + " "
		+ c.hora_atual(falso) + ":"
		+ c.minuto_atual() + ":"
		+ c.segundo_atual() 
}
	
}
