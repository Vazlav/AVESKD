﻿


Процедура ПередЗаписью(Отказ) 
	//--------------------------------------
	// Устанавливает в качестве наименования партии EAN 13
	//--------------------------------------
    Если ПараметрыСеанса.Беспредел = Ложь Тогда
		КодБезКС="24"+Формат(Число(Код), "ЧЦ=10; ЧВН=; ЧГ=0");
		Наименование=ВычислитьКонтрольнуюСумму(КодБезКС);
	КонецЕсли;
КонецПроцедуры        