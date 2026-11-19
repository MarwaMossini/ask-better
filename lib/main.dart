import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const ProshnoLabApp());

const _teal = Color(0xFF007E76);

class ProshnoLabApp extends StatelessWidget {
  const ProshnoLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProshnoLab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _teal),
        scaffoldBackgroundColor: const Color(0xFFF5F9F8),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        ),
      ),
      home: const ProshnoLabHome(),
    );
  }
}

class ProshnoLabHome extends StatefulWidget {
  const ProshnoLabHome({super.key});

  @override
  State<ProshnoLabHome> createState() => _ProshnoLabHomeState();
}

class _ProshnoLabHomeState extends State<ProshnoLabHome> {
  bool bangla = false;
  int selectedTab = 0;

  String t(String english, String bengali) => bangla ? bengali : english;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F9F8),
        title: const Row(children: [
          Icon(Icons.question_answer_rounded, color: _teal),
          SizedBox(width: 8),
          Text('ProshnoLab', style: TextStyle(fontWeight: FontWeight.w800)),
        ]),
        actions: [
          TextButton(
            onPressed: () => setState(() => bangla = !bangla),
            child: Text(bangla ? 'English' : 'বাংলা'),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: selectedTab,
          children: [
            _homePage(),
            PromptBuilder(bangla: bangla),
            LearningLibrary(bangla: bangla),
            AccountPage(bangla: bangla),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) => setState(() => selectedTab = index),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), label: t('Home', 'হোম')),
          NavigationDestination(icon: const Icon(Icons.auto_fix_high_outlined), label: t('Builder', 'প্রম্পট')),
          NavigationDestination(icon: const Icon(Icons.menu_book_outlined), label: t('Learn', 'শিখুন')),
          NavigationDestination(icon: const Icon(Icons.person_outline), label: t('Account', 'অ্যাকাউন্ট')),
        ],
      ),
    );
  }

  Widget _homePage() {
    return LayoutBuilder(builder: (context, constraints) {
      return ListView(padding: const EdgeInsets.all(18), children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFE2F3EF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t('Ask better. Save time and money.', 'ভালোভাবে প্রশ্ন করুন। সময় ও অর্থ বাঁচান।'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(t('Create useful AI prompts, learn through questions, and discover new AI tools.',
                'সহজে এআই প্রম্পট তৈরি করুন, প্রশ্নের মাধ্যমে শিখুন এবং নতুন এআই টুল জানুন।')),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => setState(() => selectedTab = 1),
              icon: const Icon(Icons.edit_outlined),
              label: Text(t('Build a prompt', 'প্রম্পট তৈরি করুন')),
            ),
          ]),
        ),
        const SizedBox(height: 22),
        Text(t('Explore ProshnoLab', 'প্রশনোল্যাব ঘুরে দেখুন'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: constraints.maxWidth < 370 ? 0.95 : 1.13,
          children: [
            _feature(Icons.auto_fix_high, t('Smart Prompts', 'স্মার্ট প্রম্পট'),
                t('Essay, email and study', 'রচনা, ইমেইল ও পড়াশোনা'), 1),
            _feature(Icons.forum_outlined, t('Questions & Answers', 'প্রশ্ন ও উত্তর'),
                t('Understand AI basics', 'এআই সম্পর্কে শিখুন'), 2),
            _feature(Icons.newspaper_outlined, t('AI & Tech Updates', 'এআই ও প্রযুক্তি'),
                t('Follow reliable sources', 'নির্ভরযোগ্য তথ্য জানুন'), 2),
            _feature(Icons.lightbulb_outline, t('Tips & Shortcuts', 'টিপস ও শর্টকাট'),
                t('Before and after examples', 'উদাহরণ থেকে শিখুন'), 2),
          ],
        ),
        const SizedBox(height: 18),
        Card(
          child: ListTile(
            leading: const Icon(Icons.shield_outlined, color: _teal),
            title: Text(t('Privacy first', 'গোপনীয়তা আগে')),
            subtitle: Text(t('Your prompt answers stay on your device in this preview.',
                'এই পরীক্ষামূলক সংস্করণে আপনার উত্তর ডিভাইসেই থাকে।')),
          ),
        ),
      ]);
    });
  }

  Widget _feature(IconData icon, String title, String description, int tab) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => setState(() => selectedTab = tab),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: _teal, size: 27),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(description, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall),
          ]),
        ),
      ),
    );
  }
}

class PromptQuestion {
  final String english;
  final String bengali;
  const PromptQuestion(this.english, this.bengali);
}

const _questions = <String, List<PromptQuestion>>{
  'essay': [
    PromptQuestion('What is your essay topic?', 'রচনার বিষয় কী?'),
    PromptQuestion('What is your education level?', 'আপনার শিক্ষার স্তর কী?'),
    PromptQuestion('What do you want help with?', 'কী ধরনের সাহায্য চান?'),
    PromptQuestion('Any word count or other requirements?', 'শব্দসংখ্যা বা অন্য শর্ত আছে?'),
  ],
  'email': [
    PromptQuestion('Who will receive the email?', 'ইমেইলটি কাকে পাঠাবেন?'),
    PromptQuestion('Why are you writing?', 'কেন লিখছেন?'),
    PromptQuestion('What details must be included?', 'কোন তথ্যগুলো রাখতে হবে?'),
    PromptQuestion('What tone would you prefer?', 'কেমন ভাষা চান?'),
  ],
  'study': [
    PromptQuestion('Which topic are you studying?', 'কোন বিষয়টি পড়ছেন?'),
    PromptQuestion('What is your current level?', 'আপনার বর্তমান স্তর কী?'),
    PromptQuestion('What is difficult or confusing?', 'কোন অংশটি কঠিন লাগছে?'),
    PromptQuestion('What kind of examples would help?', 'কেমন উদাহরণে বুঝতে সুবিধা হবে?'),
  ],
};

class PromptBuilder extends StatefulWidget {
  final bool bangla;
  const PromptBuilder({super.key, required this.bangla});

  @override
  State<PromptBuilder> createState() => _PromptBuilderState();
}

class _PromptBuilderState extends State<PromptBuilder> {
  String category = 'essay';
  final Map<String, List<TextEditingController>> answers = {};
  final TextEditingController preview = TextEditingController();

  String t(String english, String bengali) => widget.bangla ? bengali : english;

  @override
  void initState() {
    super.initState();
    for (final entry in _questions.entries) {
      answers[entry.key] = List.generate(entry.value.length, (_) => TextEditingController());
    }
  }

  @override
  void dispose() {
    for (final group in answers.values) {
      for (final field in group) {
        field.dispose();
      }
    }
    preview.dispose();
    super.dispose();
  }

  void _generate() {
    final values = answers[category]!.map((field) => field.text.trim()).toList();
    if (values.every((value) => value.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(t('Please answer at least one question.', 'অন্তত একটি প্রশ্নের উত্তর দিন।'))));
      return;
    }
    final labels = _questions[category]!;
    final details = List.generate(values.length, (index) {
      final label = widget.bangla ? labels[index].bengali : labels[index].english;
      return '- $label ${values[index].isEmpty ? t('Not provided', 'দেওয়া হয়নি') : values[index]}';
    }).join('\n');

    final instruction = switch (category) {
      'essay' => t(
          'Act as a writing coach. Help me plan an original essay. Suggest a thesis, clear outline, paragraph plan and revision checklist. Do not invent facts or references.',
          'একজন লেখার শিক্ষক হিসেবে সাহায্য করুন। একটি মৌলিক রচনার বিষয়বস্তু, রূপরেখা, অনুচ্ছেদ পরিকল্পনা ও সংশোধনের তালিকা দিন। তথ্য বা সূত্র বানিয়ে লিখবেন না।'),
      'email' => t(
          'Draft a clear, polite email based only on my details. Include a suitable subject line. Do not invent names, promises or circumstances.',
          'শুধু আমার দেওয়া তথ্য দিয়ে একটি স্পষ্ট ও ভদ্র ইমেইল লিখুন। উপযুক্ত বিষয় লিখুন। নাম বা পরিস্থিতি নিজের থেকে বানাবেন না।'),
      _ => t(
          'Act as a patient tutor. Explain the topic step by step at my level, give a worked example, then three practice questions with answers separated from the questions.',
          'ধৈর্যশীল শিক্ষক হিসেবে আমার স্তর অনুযায়ী ধাপে ধাপে বুঝিয়ে দিন, একটি সমাধানসহ উদাহরণ দিন, তারপর তিনটি অনুশীলনী প্রশ্ন ও আলাদা উত্তর দিন।'),
    };
    preview.text = '$instruction\n\n${t('My context:', 'আমার তথ্য:')}\n$details\n\n${t('Ask one brief clarifying question if an essential detail is missing.', 'জরুরি তথ্য না থাকলে একটি সংক্ষিপ্ত প্রশ্ন করুন।')}';
    setState(() {});
  }

  Future<void> _copy() async {
    if (preview.text.trim().isEmpty) return;
    await Clipboard.setData(ClipboardData(text: preview.text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t('Prompt copied. Paste it into your AI tool.', 'প্রম্পট কপি হয়েছে। আপনার এআই টুলে পেস্ট করুন।'))));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(18), children: [
      Text(t('Smart Prompt Builder', 'স্মার্ট প্রম্পট নির্মাতা'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      Text(t('Choose a task and answer a few questions.', 'একটি কাজ বেছে নিয়ে কয়েকটি প্রশ্নের উত্তর দিন।')),
      const SizedBox(height: 16),
      Wrap(spacing: 8, children: [
        for (final item in ['essay', 'email', 'study'])
          ChoiceChip(
            label: Text(switch (item) {
              'essay' => t('Essay', 'রচনা'),
              'email' => t('Email', 'ইমেইল'),
              _ => t('Study', 'পড়াশোনা'),
            }),
            selected: category == item,
            onSelected: (_) => setState(() {
              category = item;
              preview.clear();
            }),
          ),
      ]),
      const SizedBox(height: 14),
      for (var index = 0; index < _questions[category]!.length; index++) ...[
        TextField(
          key: ValueKey('$category-$index'),
          controller: answers[category]![index],
          minLines: 1,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: widget.bangla ? _questions[category]![index].bengali : _questions[category]![index].english,
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 12),
      ],
      FilledButton.icon(
        onPressed: _generate,
        icon: const Icon(Icons.auto_fix_high),
        label: Text(t('Generate my prompt', 'আমার প্রম্পট তৈরি করুন')),
      ),
      const SizedBox(height: 18),
      Text(t('Review and edit', 'দেখুন ও সম্পাদনা করুন'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(
        controller: preview,
        minLines: 8,
        maxLines: 14,
        decoration: InputDecoration(hintText: t('Your prompt will appear here.', 'আপনার প্রম্পট এখানে দেখাবে।')),
      ),
      const SizedBox(height: 10),
      OutlinedButton.icon(
        onPressed: _copy,
        icon: const Icon(Icons.copy),
        label: Text(t('Copy prompt', 'প্রম্পট কপি করুন')),
      ),
      const SizedBox(height: 10),
      Card(
        child: ListTile(
          leading: const Icon(Icons.privacy_tip_outlined, color: _teal),
          title: Text(t('Privacy checklist', 'গোপনীয়তার তালিকা')),
          subtitle: Text(t('Remove unnecessary phone numbers, addresses, IDs and private details before copying.',
              'কপি করার আগে অপ্রয়োজনীয় ফোন নম্বর, ঠিকানা, আইডি ও ব্যক্তিগত তথ্য বাদ দিন।')),
        ),
      ),
    ]);
  }
}

class LearningLibrary extends StatelessWidget {
  final bool bangla;
  const LearningLibrary({super.key, required this.bangla});
  String t(String en, String bn) => bangla ? bn : en;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
          child: Align(alignment: Alignment.centerLeft, child: Text(
            t('Learn & Discover', 'শিখুন ও জানুন'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          )),
        ),
        TabBar(tabs: [
          Tab(text: t('Q&A', 'প্রশ্নোত্তর')),
          Tab(text: t('Tips', 'টিপস')),
          Tab(text: t('Updates', 'আপডেট')),
        ]),
        Expanded(child: TabBarView(children: [
          ListView(padding: const EdgeInsets.all(12), children: [
            _qa(context, t('What is a good AI prompt?', 'ভালো এআই প্রম্পট কী?'),
                t('It states your goal, useful context, limits and the kind of answer you need. Clear requests often reduce follow-up questions.',
                    'এতে আপনার লক্ষ্য, দরকারি তথ্য, সীমাবদ্ধতা এবং কী ধরনের উত্তর চান তা স্পষ্ট থাকে।')),
            _qa(context, t('Does ProshnoLab answer questions with AI?', 'প্রশনোল্যাব কি এআই দিয়ে উত্তর দেয়?'),
                t('Not in this first version. It builds prompts you can paste into an AI tool, and this library contains prepared explanations.',
                    'প্রথম সংস্করণে নয়। এটি এআই টুলে ব্যবহার করার প্রম্পট তৈরি করে এবং এখানে আগে থেকে লেখা ব্যাখ্যা আছে।')),
            _qa(context, t('Can a better prompt remove free-plan limits?', 'ভালো প্রম্পট কি ফ্রি প্ল্যানের সীমা সরায়?'),
                t('No. Better instructions can reduce unnecessary back-and-forth but cannot change a provider’s usage limits.',
                    'না। ভালো নির্দেশনা অপ্রয়োজনীয় বার্তা কমাতে পারে, কিন্তু সেবার ব্যবহারের সীমা বদলায় না।')),
            _qa(context, t('Should I share personal information?', 'ব্যক্তিগত তথ্য কি শেয়ার করা উচিত?'),
                t('Only include information truly needed for the task. Use placeholders for private names, numbers and addresses.',
                    'কাজের জন্য একান্ত প্রয়োজনীয় তথ্যই দিন। ব্যক্তিগত নাম, নম্বর ও ঠিকানার বদলে নমুনা তথ্য দিন।')),
          ]),
          ListView(padding: const EdgeInsets.all(12), children: [
            _tip(context, t('Make the output specific', 'কেমন উত্তর চান তা বলুন'),
                t('Weak: Explain photosynthesis.', 'সাধারণ: সালোকসংশ্লেষণ বুঝিয়ে দিন।'),
                t('Better: Explain photosynthesis to a class 9 student with a simple example and three practice questions.',
                    'উন্নত: নবম শ্রেণির শিক্ষার্থীর জন্য সহজ উদাহরণ ও তিনটি অনুশীলনীসহ সালোকসংশ্লেষণ বুঝিয়ে দিন।')),
            _tip(context, t('Include context for emails', 'ইমেইলে প্রয়োজনীয় তথ্য দিন'),
                t('Weak: Write an email to my teacher.', 'সাধারণ: শিক্ষকের জন্য ইমেইল লিখুন।'),
                t('Better: Draft a polite, short email requesting an assignment extension; leave my name and dates as placeholders.',
                    'উন্নত: অ্যাসাইনমেন্টের সময় বাড়ানোর জন্য সংক্ষিপ্ত ভদ্র ইমেইল লিখুন; নাম ও তারিখের জায়গা ফাঁকা রাখুন।')),
          ]),
          ListView(padding: const EdgeInsets.all(12), children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(t('Starter sources, not a live news feed. Every future update will show its source and checked date.',
                  'এগুলো প্রাথমিক উৎস, সরাসরি সংবাদ ফিড নয়। পরের প্রতিটি আপডেটে উৎস ও যাচাইয়ের তারিখ থাকবে।')),
            ),
            _source(context, t('ChatGPT release notes', 'চ্যাটজিপিটির নতুন ফিচার'),
                'https://help.openai.com/en/articles/6825453-chatgpt-release-notes'),
            _source(context, t('Google AI updates', 'গুগলের এআই আপডেট'),
                'https://blog.google/technology/ai/'),
            _source(context, t('Microsoft AI news', 'মাইক্রোসফটের এআই সংবাদ'),
                'https://blogs.microsoft.com/blog/tag/ai/'),
          ]),
        ])),
      ]),
    );
  }

  Widget _qa(BuildContext context, String question, String answer) => Card(
    child: ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600)),
      children: [Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: Align(
          alignment: Alignment.centerLeft, child: Text(answer)))],
    ),
  );

  Widget _tip(BuildContext context, String title, String before, String after) => Card(
    child: Padding(padding: const EdgeInsets.all(15), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(before),
        const SizedBox(height: 8),
        Text(after, style: const TextStyle(color: _teal, fontWeight: FontWeight.w600)),
      ],
    )),
  );

  Widget _source(BuildContext context, String title, String url) => Card(
    child: ListTile(
      leading: const Icon(Icons.open_in_new, color: _teal),
      title: Text(title),
      subtitle: Text(url, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: IconButton(
        tooltip: t('Copy source link', 'উৎসের লিংক কপি করুন'),
        icon: const Icon(Icons.copy_outlined),
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: url));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(t('Source link copied', 'উৎসের লিংক কপি হয়েছে'))));
        },
      ),
    ),
  );
}

class AccountPage extends StatelessWidget {
  final bool bangla;
  const AccountPage({super.key, required this.bangla});
  String t(String en, String bn) => bangla ? bn : en;

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(18), children: [
      Text(t('Account & Subscription', 'অ্যাকাউন্ট ও সাবস্ক্রিপশন'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      Card(child: ListTile(
        leading: const Icon(Icons.info_outline, color: _teal),
        title: Text(t('Preview mode', 'পরীক্ষামূলক সংস্করণ')),
        subtitle: Text(t('BDApps subscription is not connected yet. No payment is collected in this version.',
            'বিডিঅ্যাপস সাবস্ক্রিপশন এখনো যুক্ত হয়নি। এই সংস্করণে কোনো টাকা নেওয়া হয় না।')),
      )),
      const SizedBox(height: 12),
      Card(child: ListTile(
        leading: const Icon(Icons.lock_outline, color: _teal),
        title: Text(t('Your privacy', 'আপনার গোপনীয়তা')),
        subtitle: Text(t('Prompt inputs stay in app memory and are not sent to ProshnoLab servers. Closing the app clears them.',
            'প্রম্পটের তথ্য শুধু অ্যাপের মেমোরিতে থাকে; সার্ভারে পাঠানো হয় না। অ্যাপ বন্ধ করলে তথ্য মুছে যায়।')),
      )),
      const SizedBox(height: 12),
      Text(t('Subscription activation, status checks and unsubscribe will be added after BDApps approval and backend testing.',
          'বিডিঅ্যাপস অনুমোদন ও ব্যাকএন্ড পরীক্ষার পর সাবস্ক্রিপশন, স্ট্যাটাস ও বাতিল করার সুবিধা যুক্ত হবে।')),
    ]);
  }
}
