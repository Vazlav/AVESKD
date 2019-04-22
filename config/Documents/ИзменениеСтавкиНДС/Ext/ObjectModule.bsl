﻿
Процедура ОбработкаЗаполнения(Основание)
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТовара") Тогда
		// Заполнение шапки
		Комментарий = Основание.Комментарий;
		Склад = Основание.Склад;
		ДокументОснование = Основание.Ссылка;
		Фирма = Основание.Фирма;
		Для Каждого ТекСтрокаТовар Из Основание.Товар Цикл
			НоваяСтрока = Товар.Добавить();
			НоваяСтрока.СтараяСуммаНДСРозн = ТекСтрокаТовар.НДСРозн;
			НоваяСтрока.Партия = ТекСтрокаТовар.Партия;
			НоваяСтрока.СтараяСтавкаНДС = ТекСтрокаТовар.СтавкаНДС;
			НоваяСтрока.СуммаРозничная = ТекСтрокаТовар.СуммаРозн;
			НоваяСтрока.Товар = ТекСтрокаТовар.Товар;
			НоваяСтрока.СтавкаНДС = ТекСтрокаТовар.Товар.СтавкаНДС;
			НоваяСтрока.СуммаНДСРозн = Окр(ТекСтрокаТовар.СуммаРозн*ТекСтрокаТовар.Товар.СтавкаНДС.Ставка/(100+ТекСтрокаТовар.Товар.СтавкаНДС.Ставка),2);
		КонецЦикла;
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПеремещениеТовара") Тогда
		// Заполнение шапки
		Комментарий = Основание.Комментарий;
		Склад = Основание.СкладПолучатель;
		ДокументОснование = Основание.Ссылка;
		Фирма = Основание.Фирма;
		
		Для Каждого ТекСтрокаТовар Из Основание.Товар Цикл
			НоваяСтрока = Товар.Добавить();
			НоваяСтрока.СтараяСуммаНДСРозн = ТекСтрокаТовар.НДСРознПол;
			НоваяСтрока.Партия = ТекСтрокаТовар.Партия;
			НоваяСтрока.СтараяСтавкаНДС = ТекСтрокаТовар.СтавкаНДС;
			НоваяСтрока.СуммаРозничная = ТекСтрокаТовар.СуммаРознПол;
			НоваяСтрока.Товар = ТекСтрокаТовар.Товар;
			НоваяСтрока.СтавкаНДС = ТекСтрокаТовар.Товар.СтавкаНДС;
			НоваяСтрока.СуммаНДСРозн = Окр(ТекСтрокаТовар.СуммаРознПол*ТекСтрокаТовар.Товар.СтавкаНДС.Ставка/(100+ТекСтрокаТовар.Товар.СтавкаНДС.Ставка),2);
		КонецЦикла;
	КонецЕсли;
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Для Каждого ТекСтрокаТовар Из Товар Цикл
		// регистр ПартииЖНВЛС Расход
		Движение = Движения.ПартииЖНВЛС.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Товар = ТекСтрокаТовар.Товар;
		Движение.Склад = Склад;
		Движение.Партия = ТекСтрокаТовар.Партия;
		Движение.СтавкаНДС = ТекСтрокаТовар.СтараяСтавкаНДС;
		Движение.Фирма = Склад.Фирма;
		Движение.Колво = 0;
		Движение.СуммаЗакупСНДС = 0;
		Движение.СуммаНДСЗакуп = 0;
		Движение.СуммаРознСНДС = 0;
		Движение.СуммаРознНДС = ТекСтрокаТовар.СтараяСуммаНДСРозн;
		Движение.ВидОперации = Перечисления.ВидыОпераций.ИзменениеСтавкиНДС;
	КонецЦикла;
	Для Каждого ТекСтрокаТовар Из Товар Цикл
		// регистр ПартииЖНВЛС Приход
		Движение = Движения.ПартииЖНВЛС.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Товар = ТекСтрокаТовар.Товар;
		Движение.Склад = Склад;
		Движение.Партия = ТекСтрокаТовар.Партия;
		Движение.СтавкаНДС = ТекСтрокаТовар.СтавкаНДС;
		Движение.Фирма = Склад.Фирма;
		Движение.Колво = 0;
		Движение.СуммаЗакупСНДС = 0;
		Движение.СуммаНДСЗакуп = 0;
		Движение.СуммаРознСНДС = 0;
		Движение.СуммаРознНДС = ТекСтрокаТовар.СуммаНДСРозн;
		Движение.ВидОперации = Перечисления.ВидыОпераций.ИзменениеСтавкиНДС;
	КонецЦикла;
	
	Товар1=Товар.Выгрузить();
	
	Товар1.Свернуть("СтавкаНДС,СтараяСтавкаНДС","СуммаРозничная,СуммаНДСРозн,СтараяСуммаНДСРозн");
	
	
	Для Каждого ТекСтрокаТовар Из Товар1 Цикл
		// регистр ОстаткиПоСтНДСПоСкладам Расход
		Движение = Движения.ОстаткиПоСтНДСПоСкладам.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Склад = Склад;
		Движение.СтавкаНДС = ТекСтрокаТовар.СтараяСтавкаНДС;
		Движение.Фирма = Склад.Фирма;
		Движение.СуммаЗакупСНДС = 0;
		Движение.СуммаНДСЗакуп = 0;
		Движение.СуммаРознСНДС = 0;
		Движение.СуммаРознНДС = ТекСтрокаТовар.СтараяСуммаНДСРозн;
		Движение.ВидОперации=Перечисления.ВидыОпераций.ИзменениеСтавкиНДС;
	КонецЦикла;
	Для Каждого ТекСтрокаТовар Из Товар1 Цикл
		// регистр ОстаткиПоСтНДСПоСкладам Приход
		Движение = Движения.ОстаткиПоСтНДСПоСкладам.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Склад = Склад;
		Движение.СтавкаНДС = ТекСтрокаТовар.СтавкаНДС;
		Движение.Фирма = Склад.Фирма;
		Движение.СуммаЗакупСНДС = 0;
		Движение.СуммаНДСЗакуп = 0;
		Движение.СуммаРознСНДС = 0;
		Движение.СуммаРознНДС = ТекСтрокаТовар.СуммаНДСРозн;
		Движение.ВидОперации=Перечисления.ВидыОпераций.ИзменениеСтавкиНДС;
	КонецЦикла;
	// записываем движения регистров
	Движения.ПартииЖНВЛС.Записать();
	Движения.ОстаткиПоСтНДСПоСкладам.Записать();
	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры


