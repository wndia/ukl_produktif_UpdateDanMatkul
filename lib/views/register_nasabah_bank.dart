import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ukl_produktif/services/user.dart';
import 'package:ukl_produktif/widgets/alert.dart'; // Tambahkan ini jika kamu punya widget alert sendiri

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final UserService user = UserService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaNasabah = TextEditingController();
  final TextEditingController alamat = TextEditingController();
  final TextEditingController telepon = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  final List<String> genderOptions = ["Laki-laki", "Perempuan"];
  String? selectedGender;
  File? imageFile;
  bool showPass = true;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    namaNasabah.dispose();
    alamat.dispose();
    telepon.dispose();
    username.dispose();
    password.dispose();
    super.dispose();
  }

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      if (imageFile == null) {
        AlertMessage()
            .showAlert(context, "Silakan pilih foto terlebih dahulu.", false);
        return;
      }

      var data = {
        "nama_nasabah": namaNasabah.text,
        "alamat": alamat.text,
        "gender": selectedGender ?? "",
        "telepon": telepon.text,
        "username": username.text,
        "password": password.text,
      };

      var result = await user.registerUser(data, imageFile);

      if (result.status == true) {
        namaNasabah.clear();
        alamat.clear();
        password.clear();
        username.clear();
        telepon.clear();
        setState(() {
          selectedGender = null;
          imageFile = null;
        });
        AlertMessage().showAlert(context, result.message, true);
      } else {
        AlertMessage().showAlert(context, result.message, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset("bank.jpg",
                        width: 150, height: 150), // Ganti dengan logo sendiri
                    const SizedBox(height: 10),
                    const Text(
                      "Bank BRI",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 222, 122, 171)),
                    ),
                    const Text(
                      "Register",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              TextFormField(
                controller: namaNasabah,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: "Nama Nasabah",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama Nasabah harus diisi" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                isExpanded: true,
                value: selectedGender,
                items: genderOptions
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value.toString();
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.badge),
                  hintText: "Pilih Gender",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) =>
                    value == null ? "Gender harus dipilih" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: alamat,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.home),
                  hintText: "Alamat",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Alamat harus diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: telepon,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  hintText: "Nomor Telepon",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nomor telepon harus diisi" : null,
              ),
              const SizedBox(height: 16),
              const Text("Foto"),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        imageFile == null ? "Pilih foto" : "Foto dipilih",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: pickImage,
                    child: const Text("Pilih"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: username,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: "Username",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Username harus diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: password,
                obscureText: showPass,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: Icon(
                        showPass ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        showPass = !showPass;
                      });
                    },
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Password harus diisi" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Color.fromRGBO(231, 193, 254, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: registerUser,
                child: const Text("Sign Up", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sudah punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Text(
                      "Login",
                      style:
                          TextStyle(color: Color.fromARGB(255, 237, 141, 208)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
