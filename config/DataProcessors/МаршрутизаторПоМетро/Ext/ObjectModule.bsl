﻿Функция СписокСтанцийПоЛинии(ЛинияМетро,НомерНачальнойСтанции,МаксУдаление,УжеПроеханоСтанций)
	
	
	Запрос=Новый запрос("ВЫБРАТЬ
	                    |	Метро.Ссылка КАК Метро,
	                    |	Метро.ПересадкаНаДругуюЛинию,
	                    |	Метро.НомерСтанцииВЛинии,
	                    |	(&НомерСтанцииВЛинии - Метро.НомерСтанцииВЛинии) * ВЫБОР
	                    |		КОГДА Метро.НомерСтанцииВЛинии > &НомерСтанцииВЛинии
	                    |			ТОГДА -1
	                    |		ИНАЧЕ 1
	                    |	КОНЕЦ + &УжеПроеханоСтанций КАК УдаленностьОтКлиента,
	                    |	Метро.ЛинияМетро КАК Линия
	                    |ИЗ
	                    |	Справочник.Метро КАК Метро
	                    |ГДЕ
	                    |	Метро.ЛинияМетро = &ЛинияМетро
	                    |	И Метро.НомерСтанцииВЛинии МЕЖДУ &НомерСтанцииВЛинии - &МаксУдаление И &НомерСтанцииВЛинии + &МаксУдаление
	                    |
	                    |УПОРЯДОЧИТЬ ПО
	                    |	УдаленностьОтКлиента"); // Сгенерировано в GtG's Консоль запросов. 26.04.2013 21:27:12
					
	Запрос.УстановитьПараметр("ЛинияМетро",ЛинияМетро);
	Запрос.УстановитьПараметр("НомерСтанцииВЛинии",НомерНачальнойСтанции);
	Запрос.УстановитьПараметр("МаксУдаление",МаксУдаление);
	Запрос.УстановитьПараметр("УжеПроеханоСтанций",УжеПроеханоСтанций);
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции	


Функция ПолучитьПересадкиСтанции(Станция)
	
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	МетроПересадки.Станция
	                    |ИЗ
	                    |	Справочник.Метро.Пересадки КАК МетроПересадки
	                    |ГДЕ
	                    |	МетроПересадки.Ссылка = &Станция");
	Запрос.УстановитьПараметр("Станция",Станция);	
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Станция"); // массив	станций других линий куда можно пересесть со Станция				
КонецФункции	




Функция ПолучитьСписокСтанцийМетро() Экспорт
	
	
	// Идея такова: Выбираем из ветки метро, на которой находится клиент все станции 
	// у которых номер между номер станции клиента - макс удаление и НСК+Макс удаление
	
	ТЗПрямогоПути=СписокСтанцийПоЛинии(СтанцияКлиента.ЛинияМетро,СтанцияКлиента.НомерСтанцииВЛинии,МаксимальноеУдалениеОтКлиента,0);
	
	// ЭлементыФормы.ВыбранныеСтанции.Значение=ТЗПрямогоПути;
	
	
	Если ИспользоватьПересадки=Истина Тогда 
		
		//
		Для Ы=1 По МаксимальноеКолвоПересадок Цикл
			СписокПутейПослеПересадки=Новый Массив;// массив ТЗпрямогоПути. после пересадки на количество станций 
			// оставшееся от проезда от станции клиента до станции пересадки
			
			ДЛя Каждого Стр Из ТЗПрямогоПути Цикл
				Если Стр.ПересадкаНаДругуюЛинию=Истина Тогда
					
					
					
					// АГА! Тут можно пересесть на другую линию и проехать по ней несколько станций в разные стороны
					// НО! На этой станции может быть пересадка на несколько линий!
					МассивСтанцийКудаМожноПересесть=ПолучитьПересадкиСтанции(Стр.Метро);
					
					Для Каждого СтанцияПересадки из МассивСтанцийКудаМожноПересесть Цикл
						ТЗКривогоПути=СписокСтанцийПоЛинии(СтанцияПересадки.ЛинияМетро,СтанцияПересадки.НомерСтанцииВЛинии,МаксимальноеУдалениеОтКлиента-Стр.УдаленностьОтКлиента,Стр.УдаленностьОтКлиента);
						// Теперь нужно снять галку пересадки у той станции, на котоую мы пересели
						СтрКП =ТЗКривогоПути.Найти(СтанцияПересадки,"Метро");
						СтрКП.ПересадкаНаДругуюЛинию=ЛОжь;
						
						СписокПутейПослеПересадки.Добавить(ТЗКривогоПути);
					КонецЦикла;
					
					// Прошарили куда ехать дальше. Теперь чтобы на след. заходе не зацепить уже обработанное
					// снимем галку с Стр.Метро что у него есть пересадка
					
					Стр.ПересадкаНаДругуюЛинию=Ложь;
				КонецЕсли;
				
			КонецЦикла;  
			//---------------<Теперь затолкаем получившийся массив кривых путей в прямой путь и отправимся на следующий заход цикла по колву пересадок>---------------------------// GtG // 26.04.2013 22:05:11
			Для Каждого КривойПуть Из СписокПутейПослеПересадки Цикл
				//Построчно  заталкиваем кривой путь в прямой
				Для Каждого СтрКривогоПути Из КривойПуть Цикл
					КриваяСтр=ТЗПрямогоПути.Добавить();
					ЗаполнитьЗначенияСвойств(КриваяСтр,СтрКривогоПути);
				КонецЦикла;
			КонецЦикла;
			
		КонецЦикла; 
		
		
	КонецЕсли;
	
	
	//---------------<На выходе получается множество вариантов как доехать с кучей пересадок>---------------------------// GtG // 26.04.2013 22:16:01
	// Свернем результат через запрос с минимальным расстоянием от клиента до станции
	// и отсеим те станции метро где аптек нет
	Запрос=Новый Запрос("ВЫБРАТЬ
	                    |	рез.Метро,
	                    |	рез.УдаленностьОтКлиента КАК УдаленностьОтКлиента,
	                    |	рез.Линия
	                    |ПОМЕСТИТЬ Рез
	                    |ИЗ
	                    |	&рез КАК рез
	                    |;
	                    |
	                    |////////////////////////////////////////////////////////////////////////////////
	                    |ВЫБРАТЬ
	                    |	Рез.Метро,
	                    |	МИНИМУМ(Рез.УдаленностьОтКлиента) КАК УдаленностьОтКлиента,
	                    |	Рез.Линия КАК Линия
	                    |ИЗ
	                    |	Рез КАК Рез
	                    |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.МестаХранения КАК МестаХранения
	                    |		ПО Рез.Метро = МестаХранения.Метро
	                    |
	                    |СГРУППИРОВАТЬ ПО
	                    |	Рез.Метро,
	                    |	Рез.Линия
	                    |
	                    |УПОРЯДОЧИТЬ ПО
	                    |	УдаленностьОтКлиента,
	                    |	Линия
	                    |;
	                    |
	                    |////////////////////////////////////////////////////////////////////////////////
	                    |УНИЧТОЖИТЬ Рез");
	Запрос.УстановитьПараметр("Рез",ТЗПрямогоПути);				
	
	Возврат  Запрос.Выполнить().Выгрузить();
	
КонецФункции