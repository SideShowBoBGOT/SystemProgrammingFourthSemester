# Лабараторна 1
# Група: ІП-11
# Виконавець: Панченко Сергій Віталійович

# Перед виконанням створимо release.asm з debug.asm
# та видалимо минулі файли білда
rm release/*
cat debug/debug.asm | awk 'NR>1{print}' | sed 's/CMAIN/_start/g' > release/release.asm

#Завдання:

#1) скомпілювати програму
nasm -felf64 release/release.asm

#2) отримати .lst файл з .asm файлу:
nasm -felf64 -l release/release.lst release/release.asm

# 4) злінкувати об'єктні файли та створити .map-файл
ld -M -o release/release.out release/release.o > release/release.map