﻿Процедура МодульМенеджера_ЗакрытьЦепочкуЗаявок(ТекущаяЗаявка) Экспорт
	
	 
	
	Запрос=Новый Запрос();
	Запрос.Текст= "	ВЫБРАТЬ
	|		ИТ_Заявка.ДокументОснование,
	|		ИТ_Заявка.Ссылка КАК ТекЗаявка
	|	ПОМЕСТИТЬ Исх
	|	ИЗ
	|		Документ.ИТ_Заявка КАК ИТ_Заявка
	|	ГДЕ
	|		ИТ_Заявка.Ссылка = &ТекущаяЗаявка
	|	;
	|	
	|	////////////////////////////////////////////////////////////////////////////////
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ИТ_Заявка.Ссылка
	|	ИЗ
	|		Исх КАК Исх
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИТ_Заявка КАК ИТ_Заявка
	|			ПО (Исх.ДокументОснование = ИТ_Заявка.Ссылка
	|					ИЛИ Исх.ТекЗаявка = ИТ_Заявка.Ссылка
	|					ИЛИ Исх.ДокументОснование = ИТ_Заявка.ДокументОснование
	|						И ИТ_Заявка.ДокументОснование.Ссылка ЕСТЬ НЕ NULL )
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ИТ_Заявка.Ссылка
	|	ИЗ
	|		Документ.ИТ_Заявка КАК ИТ_Заявка
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Исх КАК Исх
	|			ПО (Исх.ТекЗаявка = ИТ_Заявка.ДокументОснование)
	|	;
	|	//---------- Удаление временных таблиц --------------//
	|	УНИЧТОЖИТЬ  Исх ;
	|"; // Сгенерировано в GtG's Консоль запросов. 14.10.2013 17:42:59
	
	
	
	Запрос.УстановитьПараметр("ТекущаяЗаявка",ТекущаяЗаявка);
	
	Рез=Запрос.Выполнить().Выгрузить();
	
	Для Каждого Стр из рез Цикл
		Док=Стр.Ссылка.ПолучитьОбъект();
		Док.Закрыта=Истина;
		Док.Записать();
	КонеЦЦикла;	
	

	
КонецПроцедуры	