import 'package:trab_1/ServDetalhe.dart';
import 'package:trab_1/bd/banco_helper.dart';
import 'package:trab_1/clientesDetalhe.dart';
import 'package:trab_1/model/PrestServ.dart';
import 'package:trab_1/model/Servico.dart';
import 'package:trab_1/model/cliente.dart';
import 'package:trab_1/pessoa_detalhe.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MainApp());
 // runApp(const MainApp());
//}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  var bdHelper = BancoHelper();
  
  final List<PrestServ> _dados = [];
  final List<Servico> _dadosServ = [];
  final List<cliente> _dadosCliente = [];

  void carregarPessoasSalvas() async {
    var r = await bdHelper.buscarPrestServ();

    setState(() {
      _dados.clear();
      _dados.addAll(r);
    });
  }

void carregarServicosSalvos() async {
    var s = await bdHelper.buscarServ();

setState(() {
  _dados.clear();
  _dadosServ.addAll(s);
});
}

void carregarClientesSalvos() async {
    var t = await bdHelper.buscarCliente();
    setState(() {
      _dados.clear();
        _dadosCliente.addAll(t);

    });
}
  
  Future<void> inserirRegistro() async {
    var rnd = Random();

    final nomePS = 'PrestServ ${rnd.nextInt(999999)}';
    final emailPS = 'PrestServ ${rnd.nextInt(999999)}';
    final telefonePS = rnd.nextInt(99);

    Map<String, dynamic> row = {
      BancoHelper.colunaNomePSer: nomePS,
      BancoHelper.colunaEmailPSer: emailPS,
      BancoHelper.colunaTelefonePSer: telefonePS
    };

    final id = await bdHelper.inserir(row);

    print(
        'Pessoa inserida com ID $id para $nomePS');

    carregarPessoasSalvas();
  }

  void removerTudo() async {
    await bdHelper.deletarTodos();
    carregarPessoasSalvas();
    }

  @override
  void initState() {
    super.initState();
    carregarPessoasSalvas();
    carregarServicosSalvos();
    carregarClientesSalvos();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Aplicativo de Prestação de Serviço'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _dados.length, 
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_dados[index].nome ?? 'Nome não informado'),
                        //Função do click/Toque
                        onTap: () async {
                          var param = _dados[index];
                         await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PessoaDetalhePS(
                                informacaoPessoaPS: param))
                              );
                              carregarPessoasSalvas();
                        },
                      );
                    },
                  ),
                ), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          removerTudo();
                        },
                        child: const Text('Deletar Tudo')),
                  ElevatedButton(
                        onPressed: (){
                          Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServDetalhe(
                      informacaoServ: null,
                    ),
                  ),
                  ).then((value) {
                  carregarServicosSalvos();
                  });
                        },
                        child: const Text('Adicionar Serviço'),
                  ),
                  ElevatedButton(
                        onPressed: (){
                          Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClienteDetalhe(
                      informacaoCliente: null,
                    ),
                  ),
                  ).then((value) {
                  carregarClientesSalvos();
                  });
                        },
                        child: const Text('Adicionar Cliente'),
                  )
              ],
            ),
          ],
        ),
      ),
    ),    
       floatingActionButton: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton(
              child: const Icon(Icons.person_add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PessoaDetalhePS(
                      informacaoPessoaPS: null,
                    ),
                  ),
                ).then((value) {
                  carregarPessoasSalvas();
                });
              },
            );
          },
        ),
      ),
    );
  }
}
