import os

def rename_images_in_folder(folder_path):
    # Lấy danh sách file ảnh trong thư mục chapter
    files = [f for f in os.listdir(folder_path) if f.lower().endswith(('.jpg', '.jpeg', '.png', '.webp'))]
    if not files:
        return

    # Sắp xếp file theo số thứ tự hiện tại (ví dụ 2.jpg, 4.jpg, 10.jpg)
    def get_num(filename):
        num_str = ''.join(filter(str.isdigit, os.path.splitext(filename)[0]))
        return int(num_str) if num_str else 0

    files.sort(key=get_num)

    # Bước 1: Đổi tên tạm để tránh trùng tên file khi ghi đè
    for i, file in enumerate(files):
        ext = os.path.splitext(file)[1]
        old_path = os.path.join(folder_path, file)
        temp_path = os.path.join(folder_path, f"temp_{i+1}{ext}")
        os.rename(old_path, temp_path)

    # Bước 2: Đổi tên chuẩn lại từ 1, 2, 3...
    temp_files = [f for f in os.listdir(folder_path) if f.startswith("temp_")]
    temp_files.sort(key=lambda x: int(os.path.splitext(x)[0].split('_')[1]))

    for i, file in enumerate(temp_files):
        ext = os.path.splitext(file)[1]
        old_path = os.path.join(folder_path, file)
        new_path = os.path.join(folder_path, f"{i+1}{ext}")
        os.rename(old_path, new_path)

def main():
    # Quét từ thư mục chapters hiện tại
    base_dir = "." 
    
    # 1. Duyệt qua từng bộ truyện (ror, solo_leveling,...)
    manga_folders = [f.path for f in os.scandir(base_dir) if f.is_dir()]

    for manga in manga_folders:
        manga_name = os.path.basename(manga)
        # 2. Duyệt qua từng chapter trong bộ truyện đó
        chap_folders = [f.path for f in os.scandir(manga) if f.is_dir()]
        
        for chap in chap_folders:
            chap_name = os.path.basename(chap)
            print(f"🔄 Đang đổi tên ảnh: {manga_name} -> {chap_name}")
            rename_images_in_folder(chap)

    print("\n✅ Đã hoàn thành đổi tên liên tục cho toàn bộ truyện & chapter!")
    input("Nhấn Enter để thoát...")

if __name__ == "__main__":
    main()