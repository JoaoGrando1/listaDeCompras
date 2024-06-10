import 'package:flutter/material.dart';

void main() {
  runApp(AppCrud());
}

class Produto {
  String nome;
  String categoria;
  double precoMaximo;

  Produto({required this.nome, required this.categoria, required this.precoMaximo});
}

class AppCrud extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Produto',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.orange),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'images/logo.png',
                  height: 244,
                  width: 275,
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Usuário'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Verificar credenciais
                if (_usernameController.text == 'joao' &&
                    _passwordController.text == '123') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductListPage()),
                  );
                } else {
                  // Exibir mensagem de erro
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Credenciais inválidas')),
                  );
                }
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(primary: Colors.orange),
            ),
            Text('Joao Grando N15 - Squad 1'),
          ],
        ),
      ),
    );
  }
}

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  // Lista de produtos (simulando um banco de dados)
  List<Produto> products = [
    Produto(nome: 'Produto 1', categoria: 'Categoria 1', precoMaximo: 50.0),
    Produto(nome: 'Produto 2', categoria: 'Categoria 2', precoMaximo: 30.0),
    Produto(nome: 'Produto 3', categoria: 'Categoria 3', precoMaximo: 70.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Produtos'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index].nome),
            subtitle: Text('Categoria: ${products[index].categoria}\nPreço Máximo: \$${products[index].precoMaximo.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.orange),
              onPressed: () {
                // Excluir produto
                products.removeAt(index);
                // Atualizar a interface
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Produto removido')),
                );
                // Atualizar a lista de produtos
                setState(() {});
              },
            ),
            onTap: () async {
              // Editar o produto
              Produto updatedProduct = await showDialog(
                context: context,
                builder: (context) {
                  TextEditingController _nomeController =
                      TextEditingController(text: products[index].nome);
                  TextEditingController _categoriaController =
                      TextEditingController(text: products[index].categoria);
                  TextEditingController _precoMaximoController =
                      TextEditingController(text: products[index].precoMaximo.toString());

                  return AlertDialog(
                    title: Text('Editar Produto'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _nomeController,
                          decoration: InputDecoration(labelText: 'Nome'),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _categoriaController,
                          decoration: InputDecoration(labelText: 'Categoria'),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _precoMaximoController,
                          decoration: InputDecoration(labelText: 'Preço Máximo'),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Validar e salvar as alterações
                          if (_nomeController.text.isNotEmpty &&
                              _categoriaController.text.isNotEmpty &&
                              double.tryParse(_precoMaximoController.text) != null) {
                            Navigator.pop(
                              context,
                              Produto(
                                nome: _nomeController.text.trim(),
                                categoria: _categoriaController.text.trim(),
                                precoMaximo: double.parse(_precoMaximoController.text.trim()),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Preencha todos os campos corretamente')),
                            );
                          }
                        },
                        child: Text('Salvar'),
                      ),
                    ],
                  );
                },
              );

              if (updatedProduct != null) {
                // Atualizar o produto na lista
                products[index] = updatedProduct;
                // Atualizar a interface
                setState(() {});
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Adicionar novo produto
          Produto newProduct = await showDialog(
            context: context,
            builder: (context) {
              TextEditingController _nomeController = TextEditingController();
              TextEditingController _categoriaController = TextEditingController();
              TextEditingController _precoMaximoController = TextEditingController();
              return AlertDialog(
                title: Text('Novo Produto'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nomeController,
                      decoration: InputDecoration(labelText: 'Nome'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _categoriaController,
                      decoration: InputDecoration(labelText: 'Categoria'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _precoMaximoController,
                      decoration: InputDecoration(labelText: 'Preço Máximo'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_nomeController.text.isNotEmpty &&
                          _categoriaController.text.isNotEmpty &&
                          double.tryParse(_precoMaximoController.text) != null) {
                        Navigator.pop(
                          context,
                          Produto(
                            nome: _nomeController.text.trim(),
                            categoria: _categoriaController.text.trim(),
                            precoMaximo: double.parse(_precoMaximoController.text.trim()),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Preencha todos os campos corretamente')),
                        );
                      }
                    },
                    child: Text('Adicionar'),
                  ),
                ],
              );
            },
          );
          // Verificar espaço a ser alocado para a adição do novo produto
          if (newProduct != null) {
            // Adicionar o novo produto à lista
            products.add(newProduct);
            // Atualizar a tela
            setState(() {});
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
