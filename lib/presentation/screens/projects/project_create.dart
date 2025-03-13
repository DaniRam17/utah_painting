import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha
import 'package:utah_painting/providers/project_provider.dart';

class ProjectCreateScreen extends StatefulWidget {
  const ProjectCreateScreen({super.key});

  @override
  _ProjectCreateScreenState createState() => _ProjectCreateScreenState();
}

class _ProjectCreateScreenState extends State<ProjectCreateScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? selectedAdmin;
  String? selectedMembers;
  String? selectedPriority;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Proyecto Nuevo',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTextField('Nombre de la Actividad', nameController),
            const SizedBox(height: 10),
            _buildDropdown('Administrador de la actividad', ['Admin 1', 'Admin 2'], (value) {
              setState(() {
                selectedAdmin = value;
              });
            }),
            const SizedBox(height: 10),
            _buildDropdown('Integrantes de la actividad', ['Miembro 1', 'Miembro 2'], (value) {
              setState(() {
                selectedMembers = value;
              });
            }),
            const SizedBox(height: 10),
            _buildDropdown('Prioridad', ['Alta', 'Media', 'Baja'], (value) {
              setState(() {
                selectedPriority = value;
              });
            }),
            const SizedBox(height: 10),
            _buildDatePickerField('Fecha de Entrega', dateController),
            const SizedBox(height: 10),
            const Text('Comentarios:', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildTextField('', commentsController, maxLines: 3),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    Provider.of<ProjectProvider>(context, listen: false)
                        .addProject(nameController.text);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ),
    );
  }
}
