// import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConst {
  // static String get supabaseUrl     => dotenv.env['SUPABASE_URL']!;
  // static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY']!; --for production
  static const String supabaseUrl     = 'https://pouvfafvoipivubmklwp.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvdXZmYWZ2b2lwaXZ1Ym1rbHdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE4OTY4MTMsImV4cCI6MjA5NzQ3MjgxM30.Fv0jvCGdEiLJ8ZwR2H4zO--sNubOVe40c3UNYb739mY';
  static const String tasksTable = 'tasks';
}