﻿
Процедура ПередУдалением(Отказ)
	
	Если ИмяПользователя()<>"Администратор_ЭДО" Тогда
		Предупреждение("Электронный счет-фактура - это фискальный документ ! Удаление запрещено!!!",1);
		Отказ=Истина;
	КонецЕсли;
КонецПроцедуры
