﻿
Процедура ПередЗаписью(Отказ)
	
	Если ЭтотОбъект.ЭтоНовый()=Истина Тогда
		Пока Найти(ЭтотОбъект.Наименование,"  ")<>0 Цикл
			ЭтотОбъект.Наименование= СтрЗаменить(ЭтотОбъект.Наименование,"  "," ");
		КонецЦикла; 
		
		//------------------<Не должно быть дублей наименований>-------------------GtG----04.12.2007
		
		Поиск=ВРЕг( ЭтотОбъект.Наименование);
		
		ТХТ="ВЫБРАТЬ
		    |	Дозировки.Ссылка
		    |ИЗ
		    |	Справочник.Дозировки КАК Дозировки
		    |ГДЕ
		    |	Дозировки.Наименование = &Наименование";
		
		Запрос=Новый Запрос;
		Запрос.Текст=ТХТ;
		Запрос.УстановитьПараметр("Наименование",Поиск);
		
		ТЗ=Запрос.Выполнить().Выгрузить();
		
		
		Если  ТЗ.Количество()>0  Тогда  
			#Если   Клиент Тогда

			Предупреждение("Уже существует запись в справочнике!");
			#Конецесли 
			Отказ=Истина;
		КонецЕсли; 
		
	КонецЕсли; 
	
	
	
КонецПроцедуры
