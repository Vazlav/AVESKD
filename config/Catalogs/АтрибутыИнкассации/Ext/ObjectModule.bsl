﻿
Процедура ПередЗаписью(Отказ)
	
	Если НЕ РассчетныйСчет.Владелец = Поставщик Тогда
		#Если Клиент Тогда
			Предупреждение("Контрагент: " + Поставщик + " не является владельцем выбранного рассчетного счета. Запись элемента отменена.");	
		#КонецЕсли
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ РассчетныйСчетБанкаВносителя.Владелец = Поставщик Тогда
		#Если Клиент Тогда
			Предупреждение("Контрагент: " + Поставщик + " не является владельцем выбранного рассчетного счета банка вносителя. Запись элемента отменена.");	
		#КонецЕсли
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры
