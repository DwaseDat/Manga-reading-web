import os

def auto_reorder():
    folder = "." # Thư mục hiện tại
    files = [f for f in os.listdir(folder) if f.lower().endswith(('.jpg', '.png', '.webp'))]
    
    # Sắp xếp theo số hiện tại của file
    files.sort(key=lambda x: int(''.join(filter(str.isdigit, os.path.splitext(x)[0])) or 0))
    
    # Đổi tên tạm để tránh trùng
    for i, file in enumerate(files):
        ext = os.path.splitext(file)[1]
        os.rename(file, f"temp_{i+1}{ext}")
        
    # Đổi lại thành 1.jpg, 2.jpg...
    temp_files = [f for f in os.listdir(folder) if f.startswith("temp_")]
    temp_files.sort(key=lambda x: int(x.split('_')[1].split('.')[0]))
    
    for i, file in enumerate(temp_files):
        ext = os.path.splitext(file)[1]
        os.rename(file, f"{i+1}{ext}")

auto_reorder()