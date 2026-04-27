-- جدول العروض (Offers)
CREATE TABLE offers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    image_url TEXT,
    value VARCHAR(50),
    value_type VARCHAR(20), -- 'percentage' or 'fixed'
    targetAudience VARCHAR(50), -- 'all', 'new_clients', 'vip'
    status VARCHAR(20) DEFAULT 'pending', -- 'active', 'pending', 'expired'
    is_active BOOLEAN DEFAULT false,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- إضافة بعض البيانات التجريبية
INSERT INTO offers (title, description, value, value_type, targetAudience, status, is_active, start_date, end_date) VALUES
('The Gentleman''s Hour', 'A complete premium service including cut, wash, and a traditional straight razor shave with aromatherapy hot towels.', '45', 'fixed', 'all', 'active', true, '2024-01-01', '2024-12-31'),
('First Chair Welcome', 'Welcome our newest patrons with an introductory rate on any service booked during weekdays.', '20', 'percentage', 'new_clients', 'active', true, '2024-01-01', '2024-12-31'),
('The Master''s Edge', 'Focus on the beard. Precision sculpting and oil treatment for the nocturnal explorer.', '15', 'fixed', 'all', 'pending', false, '2024-10-01', '2024-10-31');

-- تفعيل RLS (Row Level Security)
ALTER TABLE offers ENABLE ROW LEVEL SECURITY;

-- سياسة القراءة للجميع
CREATE POLICY "offers_read_policy" ON offers FOR SELECT USING (true);

--上市公司 التحديث للجميع
CREATE POLICY "offers_update_policy" ON offers FOR UPDATE USING (true);

--上市公司 الإدراج للجميع
CREATE POLICY "offers_insert_policy" ON offers FOR INSERT WITH CHECK (true);

--上市公司 الحذف للجميع
CREATE POLICY "offers_delete_policy" ON offers FOR DELETE USING (true);