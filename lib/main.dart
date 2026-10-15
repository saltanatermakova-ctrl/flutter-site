import 'package:flutter/material.dart';

void main() => runApp(const FlutterSiteApp());

class FlutterSiteApp extends StatelessWidget {
  const FlutterSiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0B5FA5),
      ),
      home: const HomePage(),
    );
  }
}

class Lesson {
  final IconData icon;
  final String title;
  final String text;
  const Lesson(this.icon, this.title, this.text);
}

const lessons = <Lesson>[
  Lesson(Icons.widgets, 'Виджеты',
      'Всё в Flutter — виджет: текст, кнопка, отступ, целый экран.'),
  Lesson(Icons.view_quilt, 'Layout',
      'Row, Column, Stack и Expanded помогают расположить элементы.'),
  Lesson(Icons.sync, 'State',
      'StatefulWidget и setState обновляют экран при изменении данных.'),
  Lesson(Icons.route, 'Навигация',
      'Navigator переключает страницы и передаёт данные между ними.'),
  Lesson(Icons.fact_check, 'Формы',
      'Form и TextFormField проверяют ввод пользователя.'),
  Lesson(Icons.cloud_download, 'HTTP',
      'Запросы к API и показ списка данных на экране.'),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeKey = GlobalKey();
  final _lessonsKey = GlobalKey();
  final _contactKey = GlobalKey();

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void _send() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Спасибо, ${_nameCtrl.text}! Сообщение отправлено.')),
      );
      _formKey.currentState!.reset();
      _nameCtrl.clear();
      _emailCtrl.clear();
      _messageCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
              onPressed: () => _scrollTo(_homeKey), child: const Text('Главная')),
          TextButton(
              onPressed: () => _scrollTo(_lessonsKey), child: const Text('Уроки')),
          TextButton(
              onPressed: () => _scrollTo(_contactKey),
              child: const Text('Контакты')),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Главный блок
            Container(
              key: _homeKey,
              width: double.infinity,
              color: scheme.primaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Один код — сайт и приложение',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Text(
                        'Это учебный сайт на Flutter Web. Здесь собраны основные темы, '
                        'которые нужно знать, чтобы начать писать приложения.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 28),
                      FilledButton(
                        onPressed: () => _scrollTo(_lessonsKey),
                        child: const Text('Смотреть темы'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Темы
            Container(
              key: _lessonsKey,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Темы курса',
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          for (final l in lessons)
                            SizedBox(
                              width: 300,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(l.icon, size: 32, color: scheme.primary),
                                      const SizedBox(height: 12),
                                      Text(l.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                      const SizedBox(height: 8),
                                      Text(l.text),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Контакты
            Container(
              key: _contactKey,
              width: double.infinity,
              color: scheme.surfaceContainerHighest,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Напишите нам',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                              labelText: 'Имя', border: OutlineInputBorder()),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Введите имя'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Email', border: OutlineInputBorder()),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Введите email';
                            }
                            if (!v.contains('@') || !v.contains('.')) {
                              return 'Email должен содержать @ и точку';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _messageCtrl,
                          maxLines: 4,
                          decoration: const InputDecoration(
                              labelText: 'Сообщение',
                              border: OutlineInputBorder()),
                          validator: (v) => (v == null || v.trim().length < 5)
                              ? 'Напишите хотя бы 5 символов'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                            onPressed: _send, child: const Text('Отправить')),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: const Center(child: Text('Сделано на Flutter Web')),
            ),
          ],
        ),
      ),
    );
  }
}
