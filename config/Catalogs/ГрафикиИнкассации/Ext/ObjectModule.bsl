﻿
Функция СгенерироватьНаименование() Экспорт
	
	СтрокаНаименования = 
	?(ПонедельникАктивность, 	"пн - " + Формат(ПонедельникВремя, 	"ДФ=HH:mm; ДП=00:00") + "; ", "") 
	+ ?(ВторникАктивность, 		"вт - " + Формат(ВторникВремя, 		"ДФ=HH:mm; ДП=00:00") + "; ", "")
	+ ?(СредаАктивность, 		"ср - " + Формат(СредаВремя, 		"ДФ=HH:mm; ДП=00:00") + "; ", "")
	+ ?(ЧетвергАктивность, 		"чт - " + Формат(ЧетвергВремя, 		"ДФ=HH:mm; ДП=00:00") + "; ", "")
	+ ?(ПятницаАктивность, 		"пт - " + Формат(ПятницаВремя, 		"ДФ=HH:mm; ДП=00:00") + "; ", "")
	+ ?(СубботаАктивность, 		"сб - " + Формат(СубботаВремя, 		"ДФ=HH:mm; ДП=00:00") + "; ", "")
	+ ?(ВоскресеньеАктивность, 	"вс - " + Формат(ВоскресеньеВремя, 	"ДФ=HH:mm; ДП=00:00") + "; ", "");
	
	Если ЗначениеЗаполнено(СтрокаНаименования) Тогда
		Возврат Сред(СтрокаНаименования, 1, СтрДлина(СтрокаНаименования)-2);
	Иначе
		Возврат "<График не задан>";
	КонецЕсли;
	
КонецФункции
