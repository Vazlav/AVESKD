﻿Процедура УтвердитьИзвне(СсылкаНаДокумент) Экспорт

	// Подразумевается, что проверка на доступность операции проведена при вызове метода 
	ДокОбъект = СсылкаНаДокумент.ПолучитьОбъект();
	ДокОбъект.Утвержден = Истина;
	
	Изменение = ДокОбъект.Изменения.Добавить();
	Изменение.Дата = ТекущаяДата();
	Изменение.КомментарийИзменения = "Утвержден = " + ДокОбъект.Утвержден + ". Из документа ""МЛК""";
	Изменение.Сотрудник = ПараметрыСеанса.ТекущийСотр;
	Изменение.ТипИзм = Перечисления.ДействияНадДокументами.Изменение;
	
	Попытка
	
		ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);	
	
	Исключение
		
		#Если Клиент Тогда
		СообщитьОбОшибке(ОписаниеОшибки()); 
		#КонецЕсли 
		
	КонецПопытки;

КонецПроцедуры

Процедура СогласоватьИзвне(СсылкаНаДокумент) Экспорт
	
	// Подразумевается, что проверка на доступность операции проведена при вызове метода 
	ДокОбъект = СсылкаНаДокумент.ПолучитьОбъект();
	ДокОбъект.Согласован = Истина;
	
	Изменение = ДокОбъект.Изменения.Добавить();
	Изменение.Дата = ТекущаяДата();
	Изменение.КомментарийИзменения = "Согласован = " + ДокОбъект.Согласован + ". Из документа ""МЛК""";
	Изменение.Сотрудник = ПараметрыСеанса.ТекущийСотр;
	Изменение.ТипИзм = Перечисления.ДействияНадДокументами.Изменение;
	
	Попытка
	
		ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);	
	
	Исключение
		
		#Если Клиент Тогда
		СообщитьОбОшибке(ОписаниеОшибки()); 
		#КонецЕсли 
		
	КонецПопытки;
	
КонецПроцедуры
