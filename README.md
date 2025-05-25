## 1. What is Primary Key ও Foreign Key?

### Primary Key:

Primary key একটি  টেবিলের এমন কলাম যা প্রতিটি রেকর্ডকে **ইউনিকভাবে শনাক্ত** করে এবং সেই সাথে এটি **NOT NULL** এবং **UNIQUE** হতে হয় ।

### Foreign Key:

Foreign key একটি টেবিলের এমন কলাম যা **অন্য টেবিলের Primary Key**-কে রেফারেন্স করে এবং এটি দুই টেবিলের মধ্যে **সম্পর্ক (relationship)** তৈরি করে।

### যেমন :

```sql
CREATE TABLE author (
   id SERIAL PRIMARY KEY,
   name VARCHAR(50)
);

CREATE TABLE book (
   id SERIAL PRIMARY KEY,
   name TEXT,
   author_id INT REFERENCES author(id)
);
```
   এখানে `author` এবং `book` টেবিলের ভিতরে `author_id` ফরেন কি যেটা হয়ে `author` টেবিল এর `id` কে রেফার করার মাধ্যমে সম্পর্ক স্থাপন হয়েছে । 

---

## 2. What is the difference between the _VARCHAR_ and _CHAR_ data types?

### VARCHAR:

ভ্যারিয়েবল লেংথ স্ট্রিং, মানে যতটুকু প্রয়োজন ততটুকু জায়গা ব্যবহার করে, এটির স্টোরেজ ও পারফরম্যান্সে বেশি ভালো ।

### CHAR:

ফিক্সড লেংথ  স্ট্রিং, মানে সব সময় নির্দিষ্ট জায়গা দখল করে নেয়। যেমন : যদি `CHAR(10)` হয়, তবে `abc` ইনপুট দিলে বাকিটা স্পেস দিয়ে পূর্ণ হবে।

### সুতরাং মূল পার্থক্যগুলো হলো:

- **Length**: `VARCHAR` পরিবর্তনশীল, কিন্তু `CHAR` নির্দিষ্ট।
- **Storage**: `VARCHAR` কম স্পেস নেয়, `CHAR` তুলনায় বেশি স্পেস নেয়।
- **Performance**: ছোট ফিক্সড স্ট্রিংয়ে `CHAR` ভালো পারফর্ম করে, তবে বড় ভ্যারিয়েবল ডেটার ক্ষেত্রে `VARCHAR` বেশি কার্যকর।

---

## 3. Explain the purpose of the WHERE clause in a SELECT statement.

**WHERE** ক্লজ SQL কুইরিতে **condition** দিয়ে ডেটা ফিল্টার করার জন্য ব্যবহার করা হয়। এটি বিশাল ডেটাবেস থেকে প্রয়োজনীয় রেকর্ড বাছাই  করতে সাহায্য করে।

- এটি `SELECT`, `UPDATE`, `DELETE` সব ধরনের কুইরিতে ব্যবহার হয় এবং শুধুমাত্র যেসব রেকর্ড কন্ডিশন  পূরণ করে, সেগুলো দেখায় ।

### যেমন :

```sql
SELECT * FROM employees
WHERE salary > 50000 AND department_id = 3;
```
   এখানে where দিয়ে কন্ডিশন এর মাধ্যমে শুধু ঐ রেকর্ড গুলো দেখাবে যেগুলোর `salary` ৫ ০ ০ ০ ০  থেকে বেশি এবং `department_id` ৩। 
   
---

## 4. What are the LIMIT and OFFSET clauses used for?

### LIMIT:

আমরা একসাথে সর্বোচ্চ কতগুলো রেকর্ড দেখতে চাই, সেটি নিদিষ্ট করে দেয় limit ।

### OFFSET:

আমরা কতগুলো রেকর্ড স্কিপ করে পরবর্তী রেকর্ড দেখতে চাই সেটি offset দিয়ে সেট করতে পারি ।স্পেশালি **Pagination** বা **"Load More"** ফিচার ইমপ্লিমেন্ট করতে `LIMIT` এবং `OFFSET` খুব কাজে লাগে।

### যেমন :

```sql
SELECT * FROM products
LIMIT 10 OFFSET 20;
```
এখানে limit ১ ০ সেট করা হয়েছে তাই আমরা ১ ০  টি রেকর্ড দেখবো,সেই সাথে offset ২ ০ রাখার কারণে প্রথম ২ ০ টি রেকর্ড স্কিপ করে তার পর থেকে দেখাবে। 

---

## 5. What is the significance of the JOIN operation, and how does it work in PostgreSQL?

**JOIN** একটি  অপারেশন যা একাধিক টেবিলের ডেটাকে একসঙ্গে যোগ করার সুযোগ দেয়।

JOIN ব্যবহারে আমরা সহজেই টেবিল থেকে রিলেটেট ডেটা একত্রে দেখতে পারি ,যেমন, কোনো এমপ্লয়ি কোন ডিপার্টমেন্টে কাজ করে বা কোনো বই কোন লেখকের, ইত্যাদি।

### JOIN এর ধরনসমূহ:

- **INNER JOIN** : দুই টেবিলের মিল থাকা রেকর্ডগুলো দেখায়
- **LEFT JOIN** : বাম পাশের সব রেকর্ড দেখায়, ডান পাশে মিল না থাকলেও
- **RIGHT JOIN** : ডান পাশের সব রেকর্ড দেখায়
- **FULL JOIN** : দুই পাশের সব রেকর্ড দেখায়
- **CROSS JOIN** : প্রতিটি রেকর্ডকে অপর টেবিলের প্রতিটির সাথে জোড়া দেয়
- **NATURAL JOIN** : cross join এ  মিল থাকা কলাম যুক্ত করে দেখায়

### যেমন:

```sql
SELECT e.name, d.name
FROM employees e
JOIN departments d ON e.department_id = d.id;
```

এখানে `employees` এবং `departments` টেবিলের মধ্যে সম্পর্ক আছে `department_id` এর মাধ্যমে। তাই JOIN করে আমরা employee নাম ও departments নাম দেখতে পারবো ভিন্ন দুইটি টেবিল থাকার পরেও। 

---
