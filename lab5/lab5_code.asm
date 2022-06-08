		ORG 0x584	;Адрес начала программы
ADDR:		WORD $RES	;Ссылка на результат
MEM:		NOP		;Ячейка для записи нечетных символов
START:		CLA		;Очистка аккумулятора
S1:		IN 0x5		;Ожидание ввода нечетного символа
		AND #0x40	;Проверка на наличие введенного символа
		BEQ S1		;Нет - "Спин-луп"
		IN 0x4		;Вывод байта в AC
		OUT 0x6		;Вывод байта в ВУ-3
		ST (ADDR)	;Сохраняем символ в результат
		ST $MEM		;Сохраняем символ в "кэш"
		CMP #0x00	;Проверяем на стоп-символ
		BEQ EXIT	;Если стоп-символ - выход
		CLA		;Очистка аккумулятора
S2:		IN 0x5		;Ожидание ввода четного символа
		AND #0x40	;Проверка на наличие введенного символа
		BEQ S2		;Нет - "Спин-луп"
		IN 0x4		;Вывод байта в AC
		OUT 0x6		;Вывод байта в ВУ-3
		SWAB		;Перемещаем четный символ в старший байт
		OR $MEM		;Совмещаем с 1-м символом
		ST (ADDR)	;Сохраняем в память с автоинкрементом ссылки
		SUB $MEM	;Вычитаем 1-й символ
		SWAB		;Перемещаем четный символ в младший байт
		CMP #0x00	;Проверяем на стоп-символ
		BEQ EXIT	;Если стоп-символ - выход
		LD (ADDR)+	;Инкрементируем ссылку на результат
		CLA		;Очистка аккумулятора
		JUMP S1		;Возвращаемся в начало цикла
EXIT:		LD (ADDR)+	;Инкрементируем ссылку на результат
		CLA		;Очистка аккумулятора
		HLT		;Остановка программы
		ORG 0x5AC	;Адрес начала хранения результата
RES:		NOP