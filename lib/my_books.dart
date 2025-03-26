import 'dart:io';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyBooks extends StatefulWidget {
  const MyBooks({super.key});

  @override
  _MyBooksState createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  TextEditingController textController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration of the animation
    );
    _animation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Books"),
      ),
      body: Column(
        children: [
          AnimSearchBar(
            width: 400,
            textController: textController,
            onSuffixTap: () {
              setState(() {
                textController.clear();
              });
            }, onSubmitted: (String) {},
          ),
          Container(
            height: 65,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://plus.unsplash.com/premium_photo-1684331678124-ff62c82cef7a?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Learn Web Development',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const Row(
                        children: [
                          Text(
                            '24 Lessons',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.purple,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '2Hr 12Min',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            color: Colors.red,
                            value: _animation.value,
                            borderRadius: BorderRadius.circular(10),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>NewBook()));
        }, child: Text("Add Your Own Book")),
      )
      ,

    );
  }
}

class NewBook extends StatefulWidget {
  @override
  _NewBookState createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _totalPagesController = TextEditingController();
  File? _image;

  final ImagePicker _picker = ImagePicker();

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Collect the form data and do something with it (e.g., save it)
      String name = _nameController.text;
      String author = _authorController.text;
      int totalPages = int.tryParse(_totalPagesController.text) ?? 0;

      // Just print for now, or do whatever you need (e.g., save to database)
      print('Book Name: $name');
      print('Author: $author');
      print('Total Pages: $totalPages');
      print('Image: $_image');

      // You can reset the form here if needed
      _nameController.clear();
      _authorController.clear();
      _totalPagesController.clear();
      setState(() {
        _image = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Book"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Book Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Book Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the book name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Author Field
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: "Author"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Total Pages Field
              TextFormField(
                controller: _totalPagesController,
                decoration: InputDecoration(labelText: "Total Pages"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the total number of pages';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: _image == null
                    ? Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: Center(child: Text('Tap to pick a Cover Image')),
                )
                    : Image.file(
                  _image!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


