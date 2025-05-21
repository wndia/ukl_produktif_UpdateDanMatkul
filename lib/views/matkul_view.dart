import 'package:flutter/material.dart';
import 'package:ukl_produktif/services/matkul.dart';
import 'package:ukl_produktif/models/matkul_model.dart';

class MatkulView extends StatefulWidget {
  const MatkulView({super.key});

  @override
  State<MatkulView> createState() => _MatkulViewState();
}

class _MatkulViewState extends State<MatkulView> {
  Future<List<MatkulModel>>? futureMatkul;
  Map<int, bool> selectedMap = {};

  @override
  void initState() {
    super.initState();
    futureMatkul = MatkulService().getMatkul();
  }

  Future<void> simpanTerpilih() async {
    final snapshot = await futureMatkul;
    if (snapshot == null) return;

    final selectedMatkulList = snapshot
        .where((matkul) => selectedMap[matkul.id] == true)
        .map(
          (matkul) => {
            'id': matkul.id.toString(),
            'nama_matkul': matkul.nama_matkul,
            'sks': matkul.sks,
          },
        )
        .toList();

    if (selectedMatkulList.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Peringatan'),
          content: Text('Pilih minimal satu mata kuliah terlebih dahulu.'),
        ),
      );
      return;
    }

    try {
      final response = await MatkulService().selectMatkul({
        'list_matkul': selectedMatkulList,
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(response.status ? 'Berhasil' : 'Gagal'),
          content: Text(response.message ?? ''),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Terjadi kesalahan'),
          content: Text('Gagal menyimpan mata kuliah: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Mata Kuliah',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink.shade400,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<MatkulModel>>(
        future: futureMatkul,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.pink));
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data mata kuliah kosong'));
          } else {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    color: Colors.pink.shade100,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: const [
                        Expanded(
                            flex: 1,
                            child: Text('ID',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                            flex: 3,
                            child: Text('Mat Kul',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                            flex: 1,
                            child: Text('SKS',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                            flex: 1,
                            child: Text('Pilih',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final matkul = data[index];
                        final isSelected = selectedMap[matkul.id] ?? false;
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1, child: Text(matkul.id.toString())),
                              Expanded(
                                  flex: 3,
                                  child: Text(matkul.nama_matkul ?? '-')),
                              Expanded(
                                  flex: 1,
                                  child: Text(matkul.sks?.toString() ?? '-')),
                              Expanded(
                                flex: 1,
                                child: Checkbox(
                                  focusColor: Colors.pink.shade300,
                                  activeColor: Colors.pink.shade400,
                                  value: isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMap[matkul.id!] = value ?? false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: simpanTerpilih,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Simpan yang terpilih'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
