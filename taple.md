

# تحليل الجدول barbers (Schema)

| اسم الحقل (Column) | النوع (Type) | الوصف |
|---------------------|--------------|-------|
| `id`                | int4         | المفتاح الرئيسي (Primary Key) للحلاق. |
| `name`              | varchar      | اسم الحلاق (مثلاً: أحمد، خالد). |
| `specialty`         | varchar      | التخصص (مثلاً: حلاقة ذقن، صبغ شعر، أطفال). |
| `branch_id`         | int4         | رقم الفرع المرتبط فيه الحلاق (مهم جداً للربط مع مهم جدا عند اضافة حلالق تختار الفرع من جدول الفرع لازم يظهر). |
| `image_url`         | varchar      | رابط صورة الحلاق (لعرضها في تطبيق الفلاتر). |
| `skills`            | jsonb        | مهارات إضافية بصيغة JSON (مثل: ["تدليك", "تنظيف بشرة"]). |
| `is_available`      | bool         | هل الحلاق موجود حالياً أم في إجازة؟ (True/False). |
| `created_at`        | timestamp    | وقت إضافة الحلاق للنظام. |
| `updated_at`        | timestamp    | وقت آخر ت 

## =============================

. تحليل جدول الخدمات (services)اسم الحقل (Column)النوع (Type)الوصفidint4المفتاح الرئيسي للخدمة.namevarcharاسم الخدمة (مثلاً: قصة شعر، تنظيف بشرة).descriptiontextشرح مفصل عن الخدمة (اللي بيقرأه الـ AI للزبون).pricevarcharسعر الخدمة (نصي، يفضل تحويله لـ float8 لو بدك تعمل عمليات حسابية مستقبلاً).durationvarcharمدة الخدمة (مثلاً: "30 دقيقة").start_timetimeبداية وقت توفر الخدمة (مثلاً 09:00).end_timetimeنهاية وقت توفر الخدمة (مثلاً 22:00).break_starttimeوقت بداية الاستراحة للخدمة (لو فيه).break_endtimeوقت نهاية الاستراحة.is_activeboolهل الخدمة متاحة حالياً؟ (مهم جداً للفلترة).created_attimestampتاريخ الإضافة.updated_attimestampتاريخ التحديث.



## =============================

1. تحليل جدول صور القصات (haircut_images)اسم الحقل (Column)النوع (Type)الوصفidint4المفتاح الرئيسي للصورة.image_urlvarcharرابط الصورة (مخزن في Supabase Storage أو رابط خارجي).titlevarcharعنوان القصة (مثلاً: "قصة مدرج"، "سبايكي").descriptiontextوصف القصة (مهم للـ AI عشان يعرف يشرح الموديل للزبون).tagstextكلمات دلالية (مثل: "كلاسيك"، "شبابي").categoryvarcharالتصنيف (مثلاً: شعر، لحية، أطفال).service_idint4(مهم جداً) يربط الصورة بالخدمة الموجودة في جدول services.is_activeboolهل الموديل متوفر حالياً لعرضه؟created_attimestampتاريخ الإضافة.updated_attimestampتاريخ التحديث

## =============================
1. تحليل جدول الحجوزات (reservations)اسم الحقل (Column)النوع (Type)الوصفidint4المفتاح الرئيسي للحجز.client_namevarcharاسم العميل (بيجيبه الـ AI من المحادثة).client_phonevarcharرقم العميل (مهم جداً للربط مع واتساب).service_namevarcharاسم الخدمة المختارة (عشان تعرضها في الفلاتر فوراً).reservation_datedateتاريخ الحجز (بصيغة YYYY-MM-DD).start_timetimeوقت بداية الحجز.end_timetimeوقت نهاية الحجز (بيتحسب بناءً على مدة الخدمة).statusreservation_statusحالة الحجز (Enum مثل: pending, confirmed, cancelled).barber_namevarcharاسم الحلاق اللي اختاره الزبون.notestextأي ملاحظات إضافية من الزبون.is_paidboolهل تم الدفع؟ (مفيد لو ضفت بوابة دفع للفلاتر لاحقاً).created_at/updated_attimestampتوقيت إنشاء السجل.

## =============================

1. تحليل جدول الفروع (branches)اسم الحقل (Column)النوع (Type)الوصفidint4المفتاح الرئيسي للفرع (هذا هو الـ branchid اللي استخدمناه رقم 3).namevarcharاسم الفرع (مثلاً: فرع الرياض، فرع جدة).locationtextالعنوان التفصيلي أو رابط الخريطة.contact_numberint4رقم تواصل الفرع (انتبه: لو بيبدأ بـ 0 يفضل تحويله لـ varchar).ratingnumericتقييم الفرع (مثلاً: 4.5).is_openboolهل الفرع شغال حالياً أم مغلق للصيانة؟created_attimestampتاريخ التأسيس/الإضافة.updated_attimestampتاريخ آخر تحديث. 
## ==================== 
. تحليل جدول الأوقات المتاحة (time_slots)اسم الحقل (Column)النوع (Type)الوصفidint4المفتاح الرئيسي للساعة المتاحة.barber_idint4(مهم جداً) يربط الوقت بحلاق معين من جدول الحلاقين.start_timetimeبداية الوقت المتاح (مثلاً 10:00 AM).end_timetimeنهاية الوقت المتاح (مثلاً 11:00 AM).is_bookedboolحالة الوقت: (True = محجوز، False = متاح).created_attimestampتاريخ الإضافة.updated_attimestampتاريخ التحديث
## ==================== 