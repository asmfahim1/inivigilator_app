import 'package:get/get_navigation/src/root/internacionalization.dart';

class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US' : {

      //splash screen
      'splash_text' : 'Face Recognition APP',
      'welcome_text_title' : 'Welcome to our platform',
      'welcome_text_description' : 'Face detection applications use AI algorithms, ML, statistical analysis and image processing to find human faces within larger images and distinguish them from nonface objects such as landscapes, buildings and other human body parts.',
      'dashboard' : 'Dashboard',
      'next_btn' : 'Next',


      //login Screen
      'exams' : 'Exam type',
      'null_exam_list' : 'No exams available right now',
      'email_hint' : 'Email/User id',
      'password_hint' : 'Password',
      'login' : 'Login',
      'registration' : 'Registration',
      'welcome' : 'Invigilator DEMO APP',

      //student screen info
      'student_info_title' : "Candidate's Information",
      'attended_student' : "Attendance List",


      // loginController
      'please_wait' : 'Please Wait...',
      'no_data' : 'No data found',
      'warning' : 'Warning!',
      'error_unknown' : 'Unknown error occurred',

    },

    'bn_BD' : {
      //splash screen
      'splash_text' : 'ফেস রিকগনিশন অ্যাপ',
      'dashboard' : 'ড্যাশবোর্ড',
      'welcome_text_title' : 'আমাদের প্ল্যাটফর্মে স্বাগতম',
      'welcome_text_description' : 'ফেস ডিটেকশন অ্যাপ্লিকেশানগুলি AI অ্যালগরিদম, ML, পরিসংখ্যান বিশ্লেষণ এবং ইমেজ প্রসেসিং ব্যবহার করে বৃহত্তর চিত্রগুলির মধ্যে মানুষের মুখগুলি খুঁজে পেতে এবং ল্যান্ডস্কেপ, বিল্ডিং এবং অন্যান্য মানবদেহের অঙ্গগুলির মতো মুখবিহীন বস্তু থেকে তাদের আলাদা করতে।',
      'next_btn' : 'অগ্রসর হন',

      //login screen
      'exams' : 'পরীক্ষার ধরন',
      'null_exam_list' : 'এখন কোনো পরীক্ষার সময়সূচি নেই',
      'email_hint' : 'ইমেল/ইউজার আইডি',
      'password_hint' : 'পাসওয়ার্ড',
      'login' : 'লগইন',

      //registration screen
      'registration' : 'রেজিস্ট্রেশন',
      'welcome' : 'ইনভিজিলেটর অ্যাপে স্বাগতম',
      'photo_upload': 'আপলোড ফটো',
      'open_camera': 'ওপেন ক্যামেরা',
      'front_upload': 'আপনার মুখের সামনের দিকটি আপলোড করুন',
      'left_upload': 'আপনার মুখের ডান পাশটি আপলোড করুন',
      'right_upload': 'আপনার মুখের বাম পাশটি আপলোড করুন',
      'sign_upload': 'এখানে আপনার স্বাক্ষর আপলোড করুন',
      'complete_process': 'অনুগ্রহ করে পরীক্ষা করুন এবং প্রক্রিয়াটি সম্পূর্ণ করুন',
      'complete_btn': 'প্রক্রিয়া সম্পূর্ণ করুন',
      'completed_registration': 'আপনি সফলভাবে ___ পরীক্ষার জন্য নিবন্ধন প্রক্রিয়া সম্পন্ন করেছেন',


      //student screen info
      'student_info_title' : "পরীক্ষার্থীর তথ্য",
      'attended_student' : "উপস্থিতি তালিকা",



      // loginController
      'please_wait' : 'অনুগ্রহপূর্বক অপেক্ষা করুন...',
      'no_data' : 'No data found',
      'warning' : 'সতর্কতা',
      'error_unknown' : 'অজানা ত্রুটি ঘটেছে',

      //registration controller
      'uploading' : 'ছবি আপলোড করা হচ্ছে...',
      'no_face_found' : 'দুঃখিত কোন ফেস সনাক্ত করা হয়নি',
      'try_again_btn' : 'আবার চেষ্টা করুন',
      'no_image_selected' : 'ডিভাইস থেকে কোনো ছবি নির্বাচন করা হয়নি',
      'wait_for_a_while' : 'কিছুক্ষন অপেক্ষা করুন...',

    },
  };
}