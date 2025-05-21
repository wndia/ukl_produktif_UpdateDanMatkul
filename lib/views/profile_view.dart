import 'package:flutter/material.dart';
import 'package:ukl_produktif/services/user.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserService user = UserService();
  final _formKey = GlobalKey<FormState>();

  TextEditingController nama_pelanggan = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController telepon = TextEditingController();
  String? gender;

  final int userId = 1;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  void getProfile() async {
    var response = await user.getUserProfile();
    if (response.status == true && response.data != null) {
      var data = response.data!['data'];
      setState(() {
        nama_pelanggan.text = data['nama_pelanggan'] ?? '';
        alamat.text = data['alamat'] ?? '';
        telepon.text = data['telepon'] ?? '';
        gender = data['gender'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil data profil')),
      );
    }
  }

  void updateProfile() async {
    if (_formKey.currentState!.validate()) {
      var data = {
        "nama_pelanggan": nama_pelanggan.text,
        "alamat": alamat.text,
        "telepon": telepon.text,
        "gender": gender,
      };

      var response = await user.updateUserProfile(userId, data);
      if (response.status == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message,
                style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.purple.shade700,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.shade700,
              Colors.pink.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 12,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Profil Pengguna',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Perbarui data akun Anda',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.pink.shade100,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.purple.shade700,
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: nama_pelanggan,
                        decoration: const InputDecoration(
                          labelText: 'Nama Lengkap',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Nama tidak boleh kosong'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: alamat,
                        decoration: const InputDecoration(
                          labelText: 'Alamat',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Alamat tidak boleh kosong'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: telepon,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Telepon',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Telepon wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Jenis Kelamin',
                          prefixIcon: Icon(Icons.wc),
                          border: OutlineInputBorder(),
                        ),
                        value: gender,
                        items: const [
                          DropdownMenuItem(
                            value: 'Laki-laki',
                            child: Text('Laki-laki'),
                          ),
                          DropdownMenuItem(
                            value: 'Perempuan',
                            child: Text('Perempuan'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Pilih jenis kelamin'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan Perubahan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: updateProfile,
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/matkul');
                        },
                        child: Text(
                          'Lihat Mata Kuliah',
                          style: TextStyle(color: Colors.purple.shade400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
