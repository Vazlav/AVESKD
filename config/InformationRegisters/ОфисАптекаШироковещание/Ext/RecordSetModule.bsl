﻿//НЭТИ Барданов А.Ю. 29.01.2019 ENT-1158
Процедура ПередЗаписью(Отказ, Замещение)
	Если ЭтотОбъект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	  
	Для Каждого ТекСтрока из ЭтотОбъект Цикл
		ТекСтрока.ДатаСозданияПакета = ТекущаяДата();
	КонецЦикла;	
КонецПроцедуры
