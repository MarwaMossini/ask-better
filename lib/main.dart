import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const ProshnoLabApp());

const _teal = Color(0xFF3D6098);

class ProshnoLabApp extends StatelessWidget {
  const ProshnoLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ask Better',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _teal),
        scaffoldBackgroundColor: const Color(0xFFFAF8F3),
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
  int selectedTab = Uri.base.queryParameters['view'] == 'learn' ? 2 : 0;

  String t(String english, String bengali) => bangla ? bengali : english;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8F3),
        title: const Row(children: [
          Icon(Icons.question_answer_rounded, color: _teal),
          SizedBox(width: 8),
          Text('Ask Better', style: TextStyle(fontWeight: FontWeight.w800)),
        ]),
        actions: [
          TextButton(
            onPressed: () => setState(() => bangla = !bangla),
            child: Text(bangla ? 'English' : 'বাংলা'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
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
            color: const Color(0xFFEAF0F9),
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
            TextButton(
              onPressed: () async {
                final openBuilder = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (context) => ProshnoLabHelp(bangla: bangla),
                  ),
                );
                if (mounted && openBuilder == true) {
                  setState(() => selectedTab = 1);
                }
              },
              child: Text(t('How to use & FAQ', 'ব্যবহারবিধি ও সাধারণ জিজ্ঞাসা')),
            ),
          ]),
        ),
        const SizedBox(height: 22),
        Text(t('Explore Ask Better', 'আস্ক বেটার ঘুরে দেখুন'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: constraints.maxWidth < 370 ? 0.95 : 1.13,
          mainAxisExtent: constraints.maxWidth >= 560 ? 140 : null,
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

class ProshnoLabHelp extends StatelessWidget {
  const ProshnoLabHelp({super.key, required this.bangla});

  final bool bangla;

  String t(String english, String bengali) => bangla ? bengali : english;

  @override
  Widget build(BuildContext context) {
    final headingStyle = Theme.of(context).textTheme.titleLarge;
    final steps = [
      t('Choose Essay, Email, or Study in the Builder.', 'প্রম্পট বিল্ডারে রচনা, ইমেইল বা পড়াশোনা বেছে নিন।'),
      t('Answer the guided questions with a few details about your task.', 'আপনার কাজ সম্পর্কে কয়েকটি তথ্য দিয়ে প্রশ্নগুলোর উত্তর দিন।'),
      t('Generate your prompt, edit it if needed, then copy it into your preferred AI tool.', 'প্রম্পট তৈরি করুন, প্রয়োজনে সম্পাদনা করুন, তারপর কপি করে আপনার পছন্দের এআই টুলে পেস্ট করুন।'),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(t('How to use Ask Better', 'আস্ক বেটার কীভাবে ব্যবহার করবেন'))),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                for (var index = 0; index < steps.length; index++)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(steps[index]),
                  ),
                const SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(t('Open the builder', 'প্রম্পট বিল্ডার খুলুন')),
                  ),
                ),
                const SizedBox(height: 28),
                Semantics(
                  header: true,
                  child: Text(t('Frequently asked questions', 'সাধারণ জিজ্ঞাসা'), style: headingStyle),
                ),
                const SizedBox(height: 8),
                ExpansionTile(
                  title: Text(t('What is a prompt?', 'প্রম্পট কী?')),
                  expandedAlignment: AlignmentDirectional.centerStart,
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Text(t('A prompt is the question or instruction you give an AI tool. You can include your goal, background, and the type of answer you want.', 'প্রম্পট হলো এআই টুলকে দেওয়া প্রশ্ন বা নির্দেশনা। এতে আপনার লক্ষ্য, প্রাসঙ্গিক তথ্য ও কী ধরনের উত্তর চান তা লিখতে পারেন।')),
                  ],
                ),
                ExpansionTile(
                  title: Text(t('Does Ask Better answer my question?', 'আস্ক বেটার কি আমার প্রশ্নের উত্তর দেয়?')),
                  expandedAlignment: AlignmentDirectional.centerStart,
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Text(t('The builder prepares a prompt for you. Copy it into an AI tool, such as ChatGPT or Gemini, to get a response.', 'বিল্ডার আপনার জন্য একটি প্রম্পট তৈরি করে। উত্তর পেতে সেটি কপি করে ChatGPT বা Gemini-এর মতো কোনো এআই টুলে পেস্ট করুন।')),
                  ],
                ),
                ExpansionTile(
                  title: Text(t('Can I use Bangla?', 'আমি কি বাংলায় ব্যবহার করতে পারি?')),
                  expandedAlignment: AlignmentDirectional.centerStart,
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Text(t('Yes. Use the language button to switch between Bangla and English.', 'হ্যাঁ। ভাষার বোতাম দিয়ে বাংলা ও ইংরেজির মধ্যে বদলাতে পারবেন।')),
                  ],
                ),
                ExpansionTile(
                  title: Text(t('Do I need an account or payment?', 'অ্যাকাউন্ট খুলতে বা টাকা দিতে হবে কি?')),
                  expandedAlignment: AlignmentDirectional.centerStart,
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Text(t('The Ask Better preview is free to use without an account. Your chosen AI tool may have its own sign-in or pricing.', 'আস্ক বেটারের পরীক্ষামূলক সংস্করণ অ্যাকাউন্ট ছাড়াই বিনা মূল্যে ব্যবহার করা যায়। আপনার পছন্দের এআই টুলে আলাদা লগইন বা খরচ থাকতে পারে।')),
                  ],
                ),
                ExpansionTile(
                  title: Text(t('Where do my answers go?', 'আমার উত্তরগুলো কোথায় যায়?')),
                  expandedAlignment: AlignmentDirectional.centerStart,
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Text(t('Ask Better processes your answers in the browser or on your phone. If you paste the prompt into another service, that service handles the text under its own privacy policy.', 'আস্ক বেটার আপনার উত্তর ব্রাউজার বা ফোনেই প্রক্রিয়া করে। প্রম্পট অন্য কোনো সেবায় পেস্ট করলে সেই সেবার গোপনীয়তা নীতি প্রযোজ্য হবে।')),
                  ],
                ),
              ],
            ),
          ),
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
  'report': [
    PromptQuestion('What is the report about?', 'প্রতিবেদনের বিষয় কী?'),
    PromptQuestion('Who will read it?', 'কারা এটি পড়বেন?'),
    PromptQuestion('What findings or data can I use?', 'কোন ফলাফল বা তথ্য ব্যবহার করা যাবে?'),
    PromptQuestion('What sections or length are required?', 'কোন অংশ বা দৈর্ঘ্য প্রয়োজন?'),
  ],
  'career': [
    PromptQuestion('What role are you applying for?', 'কোন পদের জন্য আবেদন করছেন?'),
    PromptQuestion('Do you need a CV or a cover letter?', 'সিভি নাকি কভার লেটার দরকার?'),
    PromptQuestion('What skills or experience should it include?', 'কোন দক্ষতা বা অভিজ্ঞতা রাখতে হবে?'),
    PromptQuestion('Which job requirements should it address?', 'চাকরির কোন শর্তগুলো তুলে ধরতে হবে?'),
  ],
  'presentation': [
    PromptQuestion('What are you presenting?', 'কী নিয়ে উপস্থাপনা করবেন?'),
    PromptQuestion('Who is the audience?', 'শ্রোতা কারা?'),
    PromptQuestion('How long is the presentation?', 'উপস্থাপনার সময় কত?'),
    PromptQuestion('What key points must it cover?', 'কোন মূল বিষয়গুলো রাখতে হবে?'),
  ],
  'revision': [
    PromptQuestion('What text would you like to revise?', 'কোন লেখাটি সংশোধন করতে চান?'),
    PromptQuestion('What should improve?', 'কোন বিষয়টি উন্নত করতে চান?'),
    PromptQuestion('Who will read it?', 'কারা এটি পড়বেন?'),
    PromptQuestion('What tone or length should it have?', 'ভাষার ধরন বা দৈর্ঘ্য কেমন হবে?'),
  ],
  'research': [
    PromptQuestion('What topic are you investigating?', 'কোন বিষয় নিয়ে গবেষণা করছেন?'),
    PromptQuestion('What do you want to find out?', 'কী জানতে চান?'),
    PromptQuestion('What sources or data can you access?', 'কোন সূত্র বা তথ্য ব্যবহার করতে পারবেন?'),
    PromptQuestion('What limits or deadlines apply?', 'কী সীমাবদ্ধতা বা সময়সীমা আছে?'),
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
      'report' => t('Outline a report with a clear purpose, findings, limitations and next steps. Flag missing evidence.',
          'উদ্দেশ্য, ফলাফল, সীমাবদ্ধতা ও পরবর্তী পদক্ষেপসহ প্রতিবেদনের রূপরেখা দিন। প্রমাণের ঘাটতি চিহ্নিত করুন।'),
      'career' => t('Help me tailor my CV or cover letter to this opportunity using only my real experience. Suggest stronger phrasing and flag gaps.',
          'শুধু আমার বাস্তব অভিজ্ঞতা ব্যবহার করে সুযোগটির জন্য সিভি বা কভার লেটার সাজাতে সাহায্য করুন। ভালো বাক্য প্রস্তাব করুন এবং ঘাটতি চিহ্নিত করুন।'),
      'presentation' => t('Create a slide-by-slide outline with short speaker notes and a clear closing. Identify claims that need evidence.',
          'সংক্ষিপ্ত বক্তার নোট ও স্পষ্ট উপসংহারসহ প্রতিটি স্লাইডের রূপরেখা দিন। কোন দাবির প্রমাণ দরকার তা চিহ্নিত করুন।'),
      'revision' => t('Revise the supplied text for clarity. Keep its meaning and facts, and briefly explain your changes.',
          'মূল অর্থ ও তথ্য ঠিক রেখে লেখাটি আরও স্পষ্ট করুন। পরিবর্তনগুলো সংক্ষেপে ব্যাখ্যা করুন।'),
      'research' => t('Turn this idea into a focused research question and a practical plan. Suggest search terms and evidence to look for. Do not invent sources.',
          'ধারণাটি থেকে একটি নির্দিষ্ট গবেষণা প্রশ্ন ও বাস্তবসম্মত পরিকল্পনা তৈরি করুন। অনুসন্ধানের শব্দ ও প্রয়োজনীয় প্রমাণ প্রস্তাব করুন। সূত্র বানাবেন না।'),
      _ => t(
          'Act as a patient tutor. Explain the topic step by step at my level, give a worked example, then three practice questions with answers separated from the questions.',
          'ধৈর্যশীল শিক্ষক হিসেবে আমার স্তর অনুযায়ী ধাপে ধাপে বুঝিয়ে দিন, একটি সমাধানসহ উদাহরণ দিন, তারপর তিনটি অনুশীলনী প্রশ্ন ও আলাদা উত্তর দিন।'),
    };
    preview.text = '$instruction\n\n${t('My context:', 'আমার তথ্য:')}\n$details\n\n${t('Ask one brief clarifying question if an essential detail is missing.', 'জরুরি তথ্য না থাকলে একটি সংক্ষিপ্ত প্রশ্ন করুন।')}';
    setState(() {});
  }

  Future<void> _copyAndOpen(String address) async {
    final prompt = preview.text;
    if (prompt.trim().isEmpty) return;
    var copied = false;
    try {
      final copy = Clipboard.setData(ClipboardData(text: prompt));
      if (!kIsWeb) {
        await copy;
        copied = true;
      }
      final opened = await launchUrl(
        Uri.parse(address),
        mode: LaunchMode.externalApplication,
      );
      if (kIsWeb) await copy;
      copied = true;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
        opened
            ? t('Prompt copied. Paste it into the AI tool.', 'প্রম্পট কপি হয়েছে। এআই টুলে পেস্ট করুন।')
            : t('Prompt copied, but the AI tool could not open.', 'প্রম্পট কপি হয়েছে, কিন্তু এআই টুল খোলা যায়নি।'),
      )));
    } on PlatformException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
        copied
            ? t('Prompt copied, but the AI tool could not open.', 'প্রম্পট কপি হয়েছে, কিন্তু এআই টুল খোলা যায়নি।')
            : t('Could not complete the shortcut. Try Copy prompt.', 'শর্টকাট কাজ করেনি। প্রম্পট কপি করে দেখুন।'),
      )));
    }
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
      DropdownButton<String>(
        value: category,
        isExpanded: true,
        items: [
          for (final item in _questions.keys)
            DropdownMenuItem(
              value: item,
              child: Text(switch (item) {
              'essay' => t('Essay', 'রচনা'),
              'email' => t('Email', 'ইমেইল'),
              'report' => t('Report', 'প্রতিবেদন'),
              'career' => t('CV & cover letter', 'সিভি ও কভার লেটার'),
              'presentation' => t('Presentation', 'উপস্থাপনা'),
              'revision' => t('Rewrite & edit', 'পুনর্লিখন ও সম্পাদনা'),
              'research' => t('Research plan', 'গবেষণা পরিকল্পনা'),
              _ => t('Study', 'পড়াশোনা'),
            }),
            ),
        ],
        onChanged: (item) {
          if (item == null) return;
          setState(() {
            category = item;
            preview.clear();
          });
        },
      ),
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
      ValueListenableBuilder<TextEditingValue>(
        valueListenable: preview,
        builder: (context, value, child) => PopupMenuButton<String>(
          enabled: value.text.trim().isNotEmpty,
          onSelected: _copyAndOpen,
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'https://chatgpt.com/', child: Text('ChatGPT')),
            PopupMenuItem(value: 'https://gemini.google.com/', child: Text('Gemini')),
            PopupMenuItem(value: 'https://claude.ai/', child: Text('Claude')),
            PopupMenuItem(value: 'https://copilot.microsoft.com/', child: Text('Copilot')),
          ],
          child: ListTile(
            enabled: value.text.trim().isNotEmpty,
            leading: const Icon(Icons.open_in_new),
            title: Text(t('Copy and open an AI tool', 'কপি করে এআই টুল খুলুন')),
          ),
        ),
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

typedef _Lesson = ({
  int group,
  (String, String) title,
  (String, String) body,
  (String, String)? example,
});

const _lessons = <_Lesson>[
  (group: 0, title: ('What is a good AI prompt?', 'ভালো এআই প্রম্পট কী?'), body: ('It states your goal, useful context, limits and the kind of answer you need. Clear requests often reduce follow-up questions.', 'এতে আপনার লক্ষ্য, দরকারি তথ্য, সীমাবদ্ধতা এবং কী ধরনের উত্তর চান তা স্পষ্ট থাকে।'), example: null),
  (group: 0, title: ('Does Ask Better answer questions with AI?', 'আস্ক বেটার কি এআই দিয়ে উত্তর দেয়?'), body: ('Not in this first version. It builds prompts you can paste into an AI tool, and this library contains prepared explanations.', 'প্রথম সংস্করণে নয়। এটি এআই টুলে ব্যবহার করার প্রম্পট তৈরি করে এবং এখানে আগে থেকে লেখা ব্যাখ্যা আছে।'), example: null),
  (group: 0, title: ('Can a better prompt remove free-plan limits?', 'ভালো প্রম্পট কি ফ্রি প্ল্যানের সীমা সরায়?'), body: ('No. Better instructions can reduce unnecessary back-and-forth but cannot change a provider’s usage limits.', 'না। ভালো নির্দেশনা অপ্রয়োজনীয় বার্তা কমাতে পারে, কিন্তু সেবার ব্যবহারের সীমা বদলায় না।'), example: null),
  (group: 0, title: ('Should I share personal information?', 'ব্যক্তিগত তথ্য কি শেয়ার করা উচিত?'), body: ('Only include information truly needed for the task. Use placeholders for private names, numbers and addresses.', 'কাজের জন্য একান্ত প্রয়োজনীয় তথ্যই দিন। ব্যক্তিগত নাম, নম্বর ও ঠিকানার বদলে নমুনা তথ্য দিন।'), example: null),
  (group: 1, title: ('Make the output specific', 'কেমন উত্তর চান তা বলুন'), body: ('Weak: Explain photosynthesis.', 'সাধারণ: সালোকসংশ্লেষণ বুঝিয়ে দিন।'), example: ('Better: Explain photosynthesis to a class 9 student with a simple example and three practice questions.', 'উন্নত: নবম শ্রেণির শিক্ষার্থীর জন্য সহজ উদাহরণ ও তিনটি অনুশীলনীসহ সালোকসংশ্লেষণ বুঝিয়ে দিন।')),
  (group: 1, title: ('Include context for emails', 'ইমেইলে প্রয়োজনীয় তথ্য দিন'), body: ('Weak: Write an email to my teacher.', 'সাধারণ: শিক্ষকের জন্য ইমেইল লিখুন।'), example: ('Better: Draft a polite, short email requesting an assignment extension; leave my name and dates as placeholders.', 'উন্নত: অ্যাসাইনমেন্টের সময় বাড়ানোর জন্য সংক্ষিপ্ত ভদ্র ইমেইল লিখুন; নাম ও তারিখের জায়গা ফাঁকা রাখুন।')),
  (group: 2, title: ('ChatGPT release notes', 'চ্যাটজিপিটির নতুন ফিচার'), body: ('https://help.openai.com/en/articles/6825453-chatgpt-release-notes', 'https://help.openai.com/en/articles/6825453-chatgpt-release-notes'), example: null),
  (group: 2, title: ('Google AI updates', 'গুগলের এআই আপডেট'), body: ('https://blog.google/technology/ai/', 'https://blog.google/technology/ai/'), example: null),
  (group: 2, title: ('Microsoft AI news', 'মাইক্রোসফটের এআই সংবাদ'), body: ('https://blogs.microsoft.com/blog/tag/ai/', 'https://blogs.microsoft.com/blog/tag/ai/'), example: null),
];

class LearningLibrary extends StatefulWidget {
  final bool bangla;
  const LearningLibrary({super.key, required this.bangla});

  @override
  State<LearningLibrary> createState() => _LearningLibraryState();
}

class _LearningLibraryState extends State<LearningLibrary> {
  final _search = TextEditingController();

  String t(String en, String bn) => widget.bangla ? bn : en;
  String _localized((String, String) text) => t(text.$1, text.$2);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Widget _lessonCard(BuildContext context, _Lesson lesson, {bool expanded = false}) {
    final title = _localized(lesson.title);
    final body = _localized(lesson.body);
    return switch (lesson.group) {
      0 => _qa(context, title, body, expanded: expanded),
      1 => _tip(context, title, body, _localized(lesson.example!)),
      _ => _source(context, title, body),
    };
  }

  @override
  Widget build(BuildContext context) {
    final groups = [
      t('Q&A', 'প্রশ্নোত্তর'),
      t('Tips', 'টিপস'),
      t('Updates', 'আপডেট'),
    ];
    final query = _search.text.trim().toLowerCase();
    final words = query.split(RegExp(r'\s+'));
    final matches = _lessons.where((lesson) {
      final searchable = [
        lesson.title.$1, lesson.title.$2, lesson.body.$1, lesson.body.$2,
        lesson.example?.$1 ?? '', lesson.example?.$2 ?? '',
        const ['Q&A প্রশ্নোত্তর', 'Tips টিপস', 'Updates আপডেট'][lesson.group],
      ].join(' ').toLowerCase();
      return words.every(searchable.contains);
    }).toList();

    return DefaultTabController(
      length: groups.length,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  t('Learn & Discover', 'শিখুন ও জানুন'),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: t('Search the learning library', 'শেখার সংগ্রহে খুঁজুন'),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _search.text.isEmpty ? null : IconButton(
                    tooltip: t('Clear search', 'অনুসন্ধান মুছুন'),
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(_search.clear),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (query.isEmpty) ...[
          TabBar(tabs: [for (final group in groups) Tab(text: group)]),
          Expanded(child: TabBarView(children: [
            for (var group = 0; group < groups.length; group++)
              ListView(padding: const EdgeInsets.all(12), children: [
                if (group == 2)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(t('Browse these sources for AI updates.',
                        'এআই আপডেটের জন্য এই উৎসগুলো দেখুন।')),
                  ),
                for (final lesson in _lessons.where((lesson) => lesson.group == group))
                  _lessonCard(context, lesson),
              ]),
          ])),
        ] else
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Semantics(
                  header: true,
                  liveRegion: true,
                  child: Text(t('Learn / Search results', 'শিখুন / অনুসন্ধানের ফলাফল')),
                ),
                const SizedBox(height: 8),
                if (matches.isEmpty)
                  Text(t('No matches. Try a shorter keyword such as “email” or “prompt”.',
                      'কিছু পাওয়া যায়নি। “ইমেইল” বা “প্রম্পট”-এর মতো ছোট শব্দ দিয়ে খুঁজুন।')),
                for (final lesson in matches)
                  Card(
                    child: ListTile(
                      title: Text(_localized(lesson.title)),
                      subtitle: Text(groups[lesson.group]),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(builder: (context) => Scaffold(
                          appBar: AppBar(title: Text(groups[lesson.group])),
                          body: ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              Text(t('Learn / Search results / ${groups[lesson.group]}',
                                  'শিখুন / অনুসন্ধানের ফলাফল / ${groups[lesson.group]}')),
                              _lessonCard(context, lesson, expanded: true),
                            ],
                          ),
                        )),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ]),
    );
  }

  Widget _qa(BuildContext context, String question, String answer, {required bool expanded}) => Card(
    child: ExpansionTile(
      initiallyExpanded: expanded,
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
        subtitle: Text(t('Prompt inputs stay in app memory and are not sent to Ask Better servers. Closing the app clears them.',
            'প্রম্পটের তথ্য শুধু অ্যাপের মেমোরিতে থাকে; সার্ভারে পাঠানো হয় না। অ্যাপ বন্ধ করলে তথ্য মুছে যায়।')),
      )),
      const SizedBox(height: 12),
      Text(t('Subscription activation, status checks and unsubscribe will be added after BDApps approval and backend testing.',
          'বিডিঅ্যাপস অনুমোদন ও ব্যাকএন্ড পরীক্ষার পর সাবস্ক্রিপশন, স্ট্যাটাস ও বাতিল করার সুবিধা যুক্ত হবে।')),
    ]);
  }
}
