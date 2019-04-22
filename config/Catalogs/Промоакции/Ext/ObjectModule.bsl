﻿Перем ТЧВызова Экспорт;

Процедура УбратьДублиИзТаблиц() Экспорт
	
	ТЗСв = Склад.Выгрузить();
	ТЗСв.Свернуть("Код1С,Аптека","");
	Склад.Загрузить(ТЗСв);
	
	ТЗСв = ТоварныеПозиции.Выгрузить();
	ТЗСв.Свернуть("Код1С,Товар","");
	ТоварныеПозиции.Загрузить(ТЗСв);
	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	УбратьДублиИзТаблиц();	
	
	//ENT-1491 +++
	Попытка
		
		Если ЭтоНовый() ТОгда
			СпрСсылка = Справочники.Промоакции.ПолучитьСсылку();
			ЭтотОбъект.УстановитьСсылкуНового(СпрСсылка);
		Иначе
			СпрСсылка = Ссылка;
		КонецЕсли;
		
		Если ДатаПроведенияС > ТекущаяДата() Тогда 	
			УчитыватьПриРасчетеПотребности = Истина;	
		КонецЕсли; 
		
		Если ДатаПроведенияС < НачалоДня(ТекущаяДата()) и НачалоДня(ТекущаяДата())<= ДатаПроведенияПо Тогда
			ЕстьОшибка = Ложь;
			
			Для Каждого стрАпт из Склад Цикл
				НаборЗаписей = РегистрыСведений.СкоростиРозничногоАЗДляАкций.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Период.Установить(ДатаПроведенияС);
				НаборЗаписей.Отбор.Аптека.установить(СтрАпт.Аптека);
				НаборЗаписей.Прочитать();			
				Если НаборЗаписей.Количество() = 0 Тогда
					ЕстьОшибка = Истина;
					Сообщить("Для аптеки " + Строка(стрАпт.Аптека) + " на текущую дату не найдено рассчитанных скоростей");
					Продолжить;
				КонецЕсли;	
				Для Каждого стрТовар из ТоварныеПозиции Цикл
					НаборЗаписей = РегистрыСведений.СкоростиРозничногоАЗДляАкций.СоздатьНаборЗаписей();
					НаборЗаписей.Отбор.Аптека.установить(СтрАпт.Аптека);
					НаборЗаписей.Отбор.Период.Установить(ДатаПроведенияС);
					НаборЗаписей.Отбор.Товар.Установить(стрТовар.Товар);
					НаборЗаписей.Прочитать();   		
					Если НаборЗаписей.Количество() = 0 Тогда
						Сообщить("Для аптеки " + Строка(стрАпт.Аптека) + " не найден сохраненный расчет скорости по товару " + Строка(стрТовар.Товар));
						ЕстьОшибка = Истина;
						Продолжить;
					КонецЕсли;
				КонецЦикла;
				
			КонецЦикла;
			УчитыватьПриРасчетеПотребности = НЕ ЕстьОшибка;	
			Если ЕстьОшибка Тогда 
				Сообщить("По заданным условиям акции нет данных для снижения потребности по окончанию акции. Для уточнения возможности автоматического выхода из акции при расчете потребности обратитесь в поддержку");
			КонецЕсли;
		КонецЕсли;
		
		
		Если ДатаПроведенияС = НачалоДня(ТекущаяДата()) и НачалоДня(ТекущаяДата())<= ДатаПроведенияПо Тогда
			ЕстьОшибка = Ложь;		
			Для Каждого стрАпт из Склад Цикл
				НаборЗаписей = РегистрыСведений.СкоростиПродаж.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.КодАптеки.установить(СтрАпт.Код1С);
				НаборЗаписей.Прочитать();
				
				Если НаборЗаписей.Количество() = 0 Тогда
					ЕстьОшибка = Истина;
					Сообщить("Для аптеки " + Строка(стрАпт.Аптека) + " на текущую дату не найдено рассчитанных скоростей");
					Продолжить;
				КонецЕсли;
				Для Каждого стрТовар из ТоварныеПозиции Цикл
					НаборЗаписей = РегистрыСведений.СкоростиПродаж.СоздатьНаборЗаписей();
					НаборЗаписей.Отбор.КодАптеки.установить(СтрАпт.Код1С);
					НаборЗаписей.Отбор.КодТовара.Установить(стрТовар.Код1С);
					НаборЗаписей.Прочитать();   		
					Если НаборЗаписей.Количество() = 0 Тогда
						Сообщить("Для аптеки " + Строка(стрАпт.Аптека) + " не найден сохраненный расчет скорости по товару " + Строка(стрТовар.Товар));
						ЕстьОшибка = Истина;
						Продолжить;
					Иначе
						Запись = РегистрыСведений.СкоростиРозничногоАЗДляАкций.СоздатьМенеджерЗаписи();
						Запись.Период = ДатаПроведенияС;
						Запись.Аптека = стрАпт.Аптека;
						ЗАпись.Товар = стрТовар.Товар;
						Запись.Промоакция = Ссылка ; 
						Запись.Скорость = НаборЗаписей[0].скорость;
						Запись.Записать(Истина);
					КонецЕсли;
				КонецЦикла;			
			КонецЦикла;
			УчитыватьПриРасчетеПотребности = НЕ ЕстьОшибка;		
			Если ЕстьОшибка Тогда 
				Сообщить("По заданным условиям акции нет данных для снижения потребности по окончанию акции. Для уточнения возможности автоматического выхода из акции при расчете потребности обратитесь в поддержку");
			КонецЕсли;
		КонецЕсли;
		
		Если (ДатаПроведенияПо-7*24*60*60)< НачалоДня(ТекущаяДата()) и ДатаПроведенияПо >= НачалоДня(ТекущаяДата()) и УчитыватьПриРасчетеПотребности Тогда
			Сообщить("По заданным условиям акции с " + Формат(КонецДня(ТекущаяДата())+ 1,"ДЛФ=ДД") + " расчет потребности указанных аптек в акционном товаре будет ограничен показателями на начало акции");
		КонецЕсли;
	Исключение
		Ош = ИнформацияОбОшибке();
		Запись = РегистрыСведений.ЛогОшибокОбработок.СоздатьМенеджерЗаписи();
		Запись.ДатаОшибки = ТекущаяДата();
		Запись.Объект = "Суперпромо, дата проведения: " + Строка(ДатаПроведенияС);
		Запись.ОписаниеОшибки = ош.Описание;
		ЗАпись.МестоВозникновения = "Процедура ""ПередЗаписью""";
		Запись.Записать();
	КонецПопытки;
	//---
	
КонецПроцедуры

