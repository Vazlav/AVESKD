﻿
Процедура ПередЗаписью(Отказ)
	
	#Если Клиент Тогда
		Если НЕ ЗначениеЗаполнено(МакроБренд) Тогда
			Предупреждение("Не заполнен макро-бренд. Элемент не может быть записан");	
			Отказ = Истина;
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры
