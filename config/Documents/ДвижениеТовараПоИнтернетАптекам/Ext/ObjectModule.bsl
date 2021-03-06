﻿
Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр ОстаткиТовараИнтернетАптек Приход
	Движения.ОстаткиТовараИнтернетАптек.Записывать = Истина;
	Движения.ОстаткиТовараИнтернетАптек.Очистить();
	Для Каждого ТекСтрокаТовар Из Товар Цикл
		Если ТекСтрокаТовар.КоличествоОборот <> 0 Тогда
			Движение = Движения.ОстаткиТовараИнтернетАптек.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.КодАптеки = Аптека.Код;
			Движение.КодТовара = ТекСтрокаТовар.КодТовара;
			Движение.Количество = ТекСтрокаТовар.КоличествоОборот;
		КонецЕсли;
	КонецЦикла;

	// регистр ПродажиПоИнтернетАптекам 
	Движения.ПродажиПоИнтернетАптекам.Записывать = Истина;
	Движения.ПродажиПоИнтернетАптекам.Очистить();
	Для Каждого ТекСтрокаТовар Из Товар Цикл
		Если ТекСтрокаТовар.КоличествоПродаж > 0 Тогда
			Движение = Движения.ПродажиПоИнтернетАптекам.Добавить();
			Движение.Период = Дата;
			Движение.КодАптеки = Аптека.Код;
			Движение.КодТовара = ТекСтрокаТовар.КодТовара;
			Движение.Количество = ТекСтрокаТовар.КоличествоПродаж;
			Движение.СуммаПродажЗакупСНДС = ТекСтрокаТовар.СуммаПродажЗакупСНДС;
			Движение.СуммаПродажРозн = ТекСтрокаТовар.СуммаПродажРозн;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры
