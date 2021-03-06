﻿
Процедура ЗаполнитьФайлДанными(ФайлВыгрузки,Рез,СтруктураАидов,ТипДокумента)
	
	        AIDEXT	= Формат(СтруктураАидов.НашАид,"ЧГ=0");
			AID = СтруктураАидов.ВнешнийАид;
			ФайлВыгрузки.Добавить();
			
			ФайлВыгрузки.DocType	= ТипДокумента    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.AID		= AID;
			ФайлВыгрузки.AIDEXT		= AIDEXT;
			ФайлВыгрузки.NDOC		= 1    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.NBLOCK		= 1    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.NSTR		= 1    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.NField		= "ndoc";
			ФайлВыгрузки.TVAL		= "S";
			ФайлВыгрузки.Val		= Формат(Номер,"ЧГ=0");   //"S =    ;   //150,0);
			
			ФайлВыгрузки.Записать();
			//---------------<ddoc>---------------------------// GtG // 24.06.2013 20:53:48
			ФайлВыгрузки.Добавить();
			
			ФайлВыгрузки.DocType	= ТипДокумента    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.AID		= AID    ;   //"S =    ;   //30,0);
			ФайлВыгрузки.AIDEXT		= AIDEXT;
			ФайлВыгрузки.NDOC		= 1;   //"N =    ;   //15,0);
			ФайлВыгрузки.NBLOCK		= 1    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.NSTR		= 1    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.NField		= "ddoc";
			ФайлВыгрузки.TVAL		= "D";
			ФайлВыгрузки.Val		= Формат(Дата,"ДФ=yyyyMMddHHmmss");   //"S =    ;   //150,0);
			
			ФайлВыгрузки.Записать();
			
			//---------------<is_posting>---------------------------// GtG // 24.06.2013 20:53:48
			ФайлВыгрузки.Добавить();
			
			ФайлВыгрузки.DocType	= ТипДокумента    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.AID		= AID    ;   //"S =    ;   //30,0);
			ФайлВыгрузки.AIDEXT		= AIDEXT;
			ФайлВыгрузки.NDOC		= 1    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.NBLOCK		= 1    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.NSTR		= 1    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.NField		= "is_posting";
			ФайлВыгрузки.TVAL		= "B";
			ФайлВыгрузки.Val		= Число(Проведен);   //"S =    ;   //150,0);
			
			ФайлВыгрузки.Записать();
			
			//---------------<is_deleted>---------------------------// GtG // 24.06.2013 20:53:48
			ФайлВыгрузки.Добавить();
			
			ФайлВыгрузки.DocType	= ТипДокумента    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.AID		= AID    ;   //"S =    ;   //30,0);
			ФайлВыгрузки.AIDEXT		= AIDEXT;
			ФайлВыгрузки.NDOC		= 1    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.NBLOCK		= 1    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.NSTR		= 1    ;   //"N =    ;   //15,0);
			ФайлВыгрузки.NField		= "is_deleted";
			ФайлВыгрузки.TVAL		= "B";
			ФайлВыгрузки.Val		= Число(ПометкаУдаления);   //"S =    ;   //150,0);
			
			ФайлВыгрузки.Записать();	
			НомерСтр = 0;
		    КоличествоКолонок = Рез.Колонки.Количество()-1;
			Для каждого стр из Рез Цикл
				НомерСтр = НомерСтр + 1;
				
				
				Для к=1 По КоличествоКолонок Цикл  //пробегаем по значениям полей в строке
					
					ФайлВыгрузки.Добавить();
					ФайлВыгрузки.DocType	= ТипДокумента    ;   //"N =    ;   //15,0);
					ФайлВыгрузки.AID		= AID    ;   //"S =    ;   //30,0);
					ФайлВыгрузки.AIDEXT		= AIDEXT;
					ФайлВыгрузки.NDOC		= 1    ;   //"N =    ;   //15,0);
					ФайлВыгрузки.NBLOCK		= 2    ;   //"N =    ;   //15,0);
					ФайлВыгрузки.NSTR		= НомерСтр    ;   //"N =    ;   //15,0);
					
					Колонка = Рез.Колонки.Получить(к);
					Значение = стр.Получить(к);
					
					Если Колонка.Имя = "id_good" Тогда
						ФайлВыгрузки.NField	="id_good";
						ФайлВыгрузки.TVAL 	="N";
						ФайлВыгрузки.Val =Формат(Значение,"ЧГ=0");
					ИначеЕсли Колонка.Имя = "coeff" Тогда
						ФайлВыгрузки.NField ="coeff";
						ФайлВыгрузки.TVAL	="N";
						ФайлВыгрузки.Val =Формат(Значение,"ЧДЦ=0; ЧГ=0");
					ИначеЕсли Колонка.Имя = "conversion" Тогда
						ФайлВыгрузки.NField ="conversion";
						ФайлВыгрузки.TVAL ="N";
						ФайлВыгрузки.Val =Формат(Значение,"ЧДЦ=0; ЧГ=0");
					ИначеЕсли Колонка.Имя = "qnt" Тогда
						ФайлВыгрузки.NField ="qnt";
						ФайлВыгрузки.TVAL ="N";
						ФайлВыгрузки.Val =Формат(Значение,"ЧДЦ=0; ЧГ=0");	
					ИначеЕсли Колонка.Имя = "cost_r_w_nds_new" Тогда
						ФайлВыгрузки.NField ="cost_r_w_nds_new";
						ФайлВыгрузки.TVAL ="N";
						ФайлВыгрузки.Val =Формат(Значение,"ЧДЦ=2; ЧРД=.; ЧН=0; ЧГ=0");
					ИначеЕсли Колонка.Имя = "cost_r_w_nds" Тогда
						ФайлВыгрузки.NField ="cost_r_w_nds";
						ФайлВыгрузки.TVAL ="N";
						ФайлВыгрузки.Val =Формат(Значение,"ЧДЦ=2; ЧРД=.; ЧН=0; ЧГ=0");
					ИначеЕсли Колонка.Имя = "extpart" Тогда
						ФайлВыгрузки.NField ="extpart";
						ФайлВыгрузки.TVAL ="N";
						ФайлВыгрузки.Val =Формат(Значение,"ЧДЦ=0; ЧГ=0");
					ИначеЕсли Колонка.Имя = "extpart_new" Тогда
						ФайлВыгрузки.NField ="extpart_new";
						ФайлВыгрузки.TVAL ="N";
						ФайлВыгрузки.Val =Формат(Значение,"ЧДЦ=0; ЧГ=0");						
					ИначеЕсли Колонка.Имя = "barcode" Тогда
						ФайлВыгрузки.NField ="barcode";
						ФайлВыгрузки.TVAL ="S";
						ФайлВыгрузки.Val =Строка(Значение);						
					КонецЕсли;
					ФайлВыгрузки.Записать();
				КонецЦикла;
				
				
			КонецЦикла;
	
КонецПроцедуры

Функция КорректировкаСпецСимволов(Значение)
	
	//Возврат Значение;
	
   Результат = СтрЗаменить(Значение, "&", "&amp;");
   Результат = СтрЗаменить(Результат, "<", "&lt;");
   Результат = СтрЗаменить(Результат, ">", "&gt;");
   Результат = СтрЗаменить(Результат, """", "&quot;");
   Результат = СтрЗаменить(Результат, "'", "&apos;");
   Результат = СтрЗаменить(Результат, "/", "&#x2F;");	
   Возврат Результат;
   
КонецФункции

Процедура ЗаписатьЭлементXML(ЗаписьXML, Имя, Значение) 
	
	//ЗаписьXML.ЗаписатьНачалоЭлемента(Имя);
	//ЗаписьXML.ЗаписатьТекст(Значение);
	//ЗаписьXML.ЗаписатьКонецЭлемента();
	Если Значение = "" Тогда
		ЗаписьXML.ЗаписатьСтроку("<" + Имя + "/>");
	Иначе
		ЗаписьXML.ЗаписатьСтроку("<" + Имя + ">" + Значение + "</" + Имя + ">");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьНачалоЭлемента(ЗаписьXML,Имя)
	
	ЗаписьXML.ЗаписатьСтроку("<" + Имя + ">");
	
КонецПроцедуры

Процедура ЗаписатьКонецЭлемента(ЗаписьXML,Имя)
	
	ЗаписьXML.ЗаписатьСтроку("</" + Имя + ">");
	
КонецПроцедуры

Процедура ПровестиДляСтарогоПО(Отказ)
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	УРЦ.КодТовара,
	               |	УРЦ.ЦенаОбщаяНовая КАК Цена,
	               |	УРЦ.КоэффициентРазбивки,
	               |	УРЦ.СтавкаНДС,
	               |	УРЦ.Уценка
	               |ИЗ
	               |	Документ.УстановкаРозничныхЦен.Товар КАК УРЦ
	               |ГДЕ
	               |	УРЦ.Ссылка = &Ссылка
	               |	И УРЦ.ЦенаОбщаяНовая > 0
	               |	И УРЦ.ЦенаОбщаяНовая <> УРЦ.ЦенаОбщая
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	УРЦ.КодТовара,
	               |	УРЦ.КодПартии,
	               |	УРЦ.ЦенаИндивидуальнаяНовая КАК Цена,
	               |	УРЦ.Товар.ОтпускПоРецепту КАК ОтпускПоРецепту,
	               |	УРЦ.КоэффициентРазбивки,
	               |	УРЦ.СтавкаНДС,
	               |	УРЦ.Уценка
	               |ИЗ
	               |	Документ.УстановкаРозничныхЦен.Товар КАК УРЦ
	               |ГДЕ
	               |	УРЦ.Ссылка = &Ссылка
	               |	И УРЦ.ЦенаИндивидуальнаяНовая > 0
	               |	И УРЦ.ЦенаИндивидуальнаяНовая <> УРЦ.ЦенаИндивидуальная
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	УРЦ.КодТовара КАК id_good,
	               |	УРЦ.КодПартии КАК extpart,
	               |	УРЦ.КодПартии КАК extpart_new,
	               |	ВЫБОР
	               |		КОГДА (ВЫРАЗИТЬ(УРЦ.Количество * УРЦ.Коэфф / УРЦ.КоэффициентРазбивки + 0.4 КАК ЧИСЛО(15, 0))) < 1
	               |			ТОГДА 1
	               |		ИНАЧЕ ВЫРАЗИТЬ(УРЦ.Количество * УРЦ.Коэфф / УРЦ.КоэффициентРазбивки + 0.4 КАК ЧИСЛО(15, 0))
	               |	КОНЕЦ КАК qnt,
	               |	УРЦ.КоэффициентРазбивки КАК coeff,
	               |	ВЫБОР
	               |		КОГДА УРЦ.ЦенаОбщаяНовая = 0
	               |			ТОГДА УРЦ.ЦенаИндивидуальнаяНовая
	               |		ИНАЧЕ УРЦ.ЦенаОбщаяНовая
	               |	КОНЕЦ КАК cost_r_w_nds_new,
	               |	ВЫБОР
	               |		КОГДА УРЦ.ЦенаОбщая = 0
	               |			ТОГДА УРЦ.ЦенаИндивидуальная
	               |		ИНАЧЕ УРЦ.ЦенаОбщая
	               |	КОНЕЦ КАК cost_r_w_nds,
	               |	УЗ_Партии.Наименование КАК barcode,
	               |	1 КАК conversion
	               |ИЗ
	               |	Документ.УстановкаРозничныхЦен.Товар КАК УРЦ
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УЗ_Партии КАК УЗ_Партии
	               |		ПО УРЦ.КодПартии = УЗ_Партии.Код
	               |ГДЕ
	               |	УРЦ.Ссылка = &Ссылка
	               |	И (УРЦ.ЦенаОбщаяНовая > 0
	               |			ИЛИ УРЦ.ЦенаИндивидуальнаяНовая > 0)";
	Запрос.УстановитьПараметр("Ссылка",Ссылка);			   
	Результат = Запрос.ВыполнитьПакет();
	
	ОбщиеЦены = Результат[0].Выбрать();
	ИндЦены	  = Результат[1].Выбрать();
	ЦеныВФайл = Результат[2].Выгрузить();

	
	Если ОбщиеЦены.Количество() > 0 Тогда
		УстановитьОбщиеЦены(ОбщиеЦены);
	КонецЕсли;
	
	Если ИндЦены.Количество() > 0 Тогда
		УстановитьИндивидуальныеЦены(ИндЦены);
	КонецЕсли;	
	
	ВыгрузитьЦеныВФайл(ЦеныВФайл,Отказ);
	
КонецПроцедуры

Процедура ПровестиДляНовогоПО(Отказ)
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Выборка.КодТовара,
	               |	ВЫБОР
	               |		КОГДА Выборка.КоэффициентРазбивки > 1
	               |				И (ВЫРАЗИТЬ(Выборка.Цена / Выборка.КоэффициентРазбивки КАК ЧИСЛО(15, 1))) <> Выборка.Цена / Выборка.КоэффициентРазбивки
	               |			ТОГДА (ВЫРАЗИТЬ(Выборка.Цена / Выборка.КоэффициентРазбивки КАК ЧИСЛО(15, 1))) * Выборка.КоэффициентРазбивки
	               |		ИНАЧЕ Выборка.Цена
	               |	КОНЕЦ КАК Цена,
	               |	Выборка.КоэффициентРазбивки,
	               |	Выборка.СтавкаНДС
	               |ИЗ
	               |	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |		УстановкаРозничныхЦенТовар.КодТовара КАК КодТовара,
	               |		МАКСИМУМ(УстановкаРозничныхЦенТовар.ЦенаОбщаяНовая) КАК Цена,
	               |		МАКСИМУМ(УстановкаРозничныхЦенТовар.КоэффициентРазбивки) КАК КоэффициентРазбивки,
	               |		МАКСИМУМ(УстановкаРозничныхЦенТовар.СтавкаНДС) КАК СтавкаНДС
	               |	ИЗ
	               |		Документ.УстановкаРозничныхЦен.Товар КАК УстановкаРозничныхЦенТовар
	               |	ГДЕ
	               |		УстановкаРозничныхЦенТовар.Ссылка = &Ссылка
	               |		И УстановкаРозничныхЦенТовар.ЦенаОбщаяНовая > 0
	               |		И УстановкаРозничныхЦенТовар.ЦенаОбщаяНовая <> УстановкаРозничныхЦенТовар.ЦенаОбщая
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		УстановкаРозничныхЦенТовар.КодТовара) КАК Выборка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	УстановкаРозничныхЦенТовар.КодТовара,
	               |	УстановкаРозничныхЦенТовар.КодПартии,
	               |	УстановкаРозничныхЦенТовар.ЦенаИндивидуальнаяНовая КАК Цена,
	               |	УстановкаРозничныхЦенТовар.Товар.ОтпускПоРецепту КАК ОтпускПоРецепту,
	               |	УстановкаРозничныхЦенТовар.КоэффициентРазбивки,
	               |	УстановкаРозничныхЦенТовар.СтавкаНДС,
	               |	УстановкаРозничныхЦенТовар.Уценка
	               |ИЗ
	               |	Документ.УстановкаРозничныхЦен.Товар КАК УстановкаРозничныхЦенТовар
	               |ГДЕ
	               |	УстановкаРозничныхЦенТовар.Ссылка = &Ссылка
	               |	И УстановкаРозничныхЦенТовар.ЦенаИндивидуальнаяНовая > 0
	               |	И УстановкаРозничныхЦенТовар.ЦенаИндивидуальнаяНовая <> УстановкаРозничныхЦенТовар.ЦенаИндивидуальная";
	Запрос.УстановитьПараметр("Ссылка",Ссылка);			   
	Результат = Запрос.ВыполнитьПакет();
	
	ОбщиеЦены = Результат[0].Выбрать();
	ИндЦены	  = Результат[1].Выбрать();
	
	Если ОбщиеЦены.Количество() > 0 Тогда
		УстановитьОбщиеЦены(ОбщиеЦены);
		ОбщиеЦены.Сбросить();
		Если НЕ ОтложенныеЦены Тогда
			ВыгрузитьОбщиеЦены(ОбщиеЦены);
		КонецЕсли;
	КонецЕсли;
	
	Если ИндЦены.Количество() > 0 Тогда
		УстановитьИндивидуальныеЦены(ИндЦены);
		ИндЦены.Сбросить();
		Если НЕ ОтложенныеЦены Тогда
			ВыгрузитьИндивидуальныеЦены(ИндЦены);
		КонецЕсли;
	КонецЕсли;	
	
	
КонецПроцедуры

Процедура ВыгрузитьЦеныВФайл(Выборка,Отказ)
	
		ТипДокумента = 234;
		СтруктураАидов = Обмен.СоздатьЗаписьВРеестре(Ссылка,ТипДокумента);
		Если СтруктураАидов = Неопределено Тогда
			#Если Клиент Тогда
				Сообщить("Не удалось создать запись в реестре документов. Документ не может быть выгружен");
			#КонецЕсли
			Отказ = Истина;
			Возврат;

		КонецЕсли;		
		
		
		КаталогОбмена=Склад.КаталогОбмена;
		КаталогОбъект = Новый Файл(КаталогОбмена);
		Если НЕ КаталогОбъект.Существует() Тогда
			#Если Клиент Тогда
				Сообщить("НЕ существует каталога: " + КаталогОбмена + " для аптеки : " + Склад );
			#КонецЕсли
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		
		Если СокрЛП(КаталогОбмена) = "" Тогда
			#Если Клиент Тогда
				Сообщить("----------------------------------------------------------------------------------------" );
				Сообщить("НЕ задан каталог обмена для аптеки : " + Склад );
				Сообщить("распоряжение не выгружено" );
				Сообщить("----------------------------------------------------------------------------------------" );
			#КонецЕсли
			Отказ = Истина;
			Возврат;
		КонецЕсли;


		//
		//ТХТ = "ВЫБРАТЬ
		//      |	РаспоряжениеНаПереоценкуТовар.Товар.Код КАК id_good,
		//      |	РаспоряжениеНаПереоценкуТовар.К КАК coeff,
		//      |	РаспоряжениеНаПереоценкуТовар.Количество КАК qnt,
		//      |	РаспоряжениеНаПереоценкуТовар.НоваяЦена КАК cost_r_w_nds_new,
		//      |	РаспоряжениеНаПереоценкуТовар.СтараяЦена КАК cost_r_w_nds,
		//      |	РаспоряжениеНаПереоценкуТовар.Партия.Код КАК extpart,
		//      |	РаспоряжениеНаПереоценкуТовар.ПартияНовая.Код КАК extpart_new,
		//      |	РаспоряжениеНаПереоценкуТовар.ПартияНовая.Наименование КАК barcode,
		//      |	ВЫБОР
		//      |		КОГДА РаспоряжениеНаПереоценкуТовар.Товар.ЕдиницаПоУмолчанию.К > 1
		//      |				И РаспоряжениеНаПереоценкуТовар.К = 1
		//      |				И РаспоряжениеНаПереоценкуТовар.Партия.ЕИТЗакупки.К > 1
		//      |			ТОГДА РаспоряжениеНаПереоценкуТовар.Товар.ЕдиницаПоУмолчанию.К
		//      |		ИНАЧЕ 1
		//      |	КОНЕЦ КАК conversion
		//      |ИЗ
		//      |	Документ.РаспоряжениеНаПереоценку.Товар КАК РаспоряжениеНаПереоценкуТовар
		//      |ГДЕ
		//      |	РаспоряжениеНаПереоценкуТовар.Ссылка = &Ссылка";		
		//
		//Запрос = Новый Запрос;
		//запрос.Текст = ТХТ;
		//Запрос.УстановитьПараметр("Ссылка",Ссылка);
		//Рез = Запрос.Выполнить().Выгрузить();
		//
		
		
		ФайлВыгрузки=Новый XBase();
		ФайлВыгрузки.Кодировка=КодировкаXBase.OEM;
		
		ФайлВыгрузки.поля.Добавить("DocType","N",15,0);
		ФайлВыгрузки.поля.Добавить("AID","S",20,0);
		ФайлВыгрузки.поля.Добавить("AIDEXT","S",15,0);
		ФайлВыгрузки.поля.Добавить("NDOC","N",15,0);
		ФайлВыгрузки.поля.Добавить("NBLOCK","N",15,0);
		ФайлВыгрузки.поля.Добавить("NSTR","N",15,0);
		ФайлВыгрузки.поля.Добавить("NField","S",30,0);
		ФайлВыгрузки.поля.Добавить("TVAL","S",1,0);
		ФайлВыгрузки.поля.Добавить("Val","S",150,0);
		
		ИмяФайлаВыгрузки=КаталогОбмена+"indocs"+Формат(Склад.код,"ЧГ=")+"_"+Формат(ТекущаяДата(),"ДФ=yyyyMMddHHmmss")+"_"+Формат(Номер,"ЧГ=0")+".zip";
		Уник = Новый УникальныйИдентификатор;
		Уник = Прав(Уник,8);
		ИмяВременногоДБФ=КаталогВременныхФайлов()+Уник+".dbf";
		
		ФайлВыгрузки.СоздатьФайл(ИмяВременногоДБФ);
		
        ЗаполнитьФайлДанными(ФайлВыгрузки,Выборка,СтруктураАидов,ТипДокумента);
		
		ФайлВыгрузки.ЗакрытьФайл();
		
		ИмяФайлаДляАрхивации=СтрЗаменить(ИмяВременногоДБФ,"\"+Уник + ".","\indocs"+Формат(Склад.код,"ЧГ=")+"_"+Формат(ТекущаяДата(),"ДФ=yyyyMMddHHmmss")+"_"+Формат(Номер,"ЧГ=0")+".");
		
		ПереместитьФайл(ИмяВременногоДБФ,ИмяФайлаДляАрхивации);
		
		
		ОМ17_ЗапаковатьФайлИСкопироватьЕгоВПапку(ИмяФайлаДляАрхивации,ИмяФайлаВыгрузки);
		
		УдалитьФайлы(ИмяФайлаДляАрхивации);
		
	
		
	
КонецПроцедуры

Процедура ВыгрузитьОбщиеЦены(Выборка)
	
	ИмяФайла = ПолучитьИмяВременногоФайла("XML");
	
	ЗаписьXML = Новый ЗаписьТекста(ИмяФайла,"windows-1251");
	
	
	ЗаписьXML.ЗаписатьСтроку("<?xml version=""1.0"" encoding=""WINDOWS-1251""?>");

	ЗаписьXML.ЗаписатьСтроку("<document>"); 

	
	ЗаписатьЭлементXML(ЗаписьXML, "pack_type", "PRICE_GOODS"); 
	ЗаписатьЭлементXML(ЗаписьXML, "fmt_ver", "1"); 
	
	ЗаписьXML.ЗаписатьСтроку("<price_goods>");
 

	Пока Выборка.Следующий() Цикл
		ЗаписьXML.ЗаписатьСтроку("<row>");
		ЗаписатьЭлементXML(ЗаписьXML, "ndoc",	Формат(Номер,"ЧГ=0"));
		ЗаписатьЭлементXML(ЗаписьXML, "ddoc", Формат(Дата,"ДФ=dd.MM.yyyy"));		
		ЗаписатьЭлементXML(ЗаписьXML, "id_goods",	Формат(Выборка.КодТовара,"ЧГ=0"));
		ЗаписатьЭлементXML(ЗаписьXML, "cost_rtl_w_vat_pack", Формат(Выборка.Цена,"ЧРД=.; ЧГ=0") );
		ЗаписьXML.ЗаписатьСтроку("</row>");
	КонецЦикла;
	
	ЗаписьXML.ЗаписатьСтроку("</price_goods>");
	ЗаписьXML.ЗаписатьСтроку("</document>"); //конец записи секции  "STORING_PLACE"
	
	ЗаписьXML.Закрыть();
	ЗаписьXML = Новый ЧтениеТекста(ИмяФайла,"windows-1251");
	ВесьТекст = ЗаписьXML.Прочитать();
	ЗаписьXML.Закрыть();
	УдалитьФайлы(ИмяФайла);

	
	//Получение кода заменено на тригер в БД tr_InfoRg6145_bi
	//КодСчетчика = ОМ_ТСО.ПолучитьКодСчетчика("ОбменАптекаОфисЦелевые");
	//Если КодСчетчика = -1 Тогда
	//	КодСчетчика = ОМ_ТСО.ПолучитьКодСчетчика("ОбменАптекаОфисЦелевые");
	//	Если КодСчетчика = -1 Тогда
	//		Возврат;	
	//	КонецЕсли;
	//КонецЕсли;
	
	МЗ = РегистрыСведений.ОфисАптекаЦелевые.СоздатьМенеджерЗаписи();
	МЗ.Код = 1;
	МЗ.КодАптеки = Склад.Код;
	МЗ.ТипУпаковки = "PRICE_GOODS";
	МЗ.Приоритет = 1;
	МЗ.ВерсияФормата = 1;
	МЗ.ИмяФайла = "price_goods_" + СокрЛП(Формат(Склад.Код,"ЧГ=0")) + "_" + Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy.ЧЧ.мм.сс") +".xml";
	МЗ.ИдентификаторКодировки = 1;
	МЗ.ХМЛСтрока = ВесьТекст;
	МЗ.Записать();	
	
	
КонецПроцедуры

Процедура ВыгрузитьИндивидуальныеЦены(Выборка)
	
	ИмяФайла = ПолучитьИмяВременногоФайла("XML");
	
	ЗаписьXML = Новый ЗаписьТекста(ИмяФайла,"windows-1251");

	
	ЗаписьXML.ЗаписатьСтроку("<?xml version=""1.0"" encoding=""WINDOWS-1251""?>");

	ЗаписьXML.ЗаписатьСтроку("<document>"); 

	
	ЗаписатьЭлементXML(ЗаписьXML, "pack_type", "PRICE_GPART"); 
	ЗаписатьЭлементXML(ЗаписьXML, "fmt_ver", "1"); 
	
	
	ЗаписьXML.ЗаписатьСтроку("<price_gpart>");
		Пока Выборка.Следующий() Цикл
			ЗаписьXML.ЗаписатьСтроку("<row>");
				ЗаписатьЭлементXML(ЗаписьXML, "ndoc",	Формат(Номер,"ЧГ=0")); 
				ЗаписатьЭлементXML(ЗаписьXML, "ddoc", Формат(Дата,"ДФ=dd.MM.yyyy"));			
				ЗаписатьЭлементXML(ЗаписьXML, "guid_gpart",	Формат(Выборка.КодПартии,"ЧГ=0"));
				ЗаписатьЭлементXML(ЗаписьXML, "cost_rtl_w_vat_pack", Формат(Выборка.Цена,"ЧРД=.; ЧГ=0") );
				ЗаписатьЭлементXML(ЗаписьXML, "is_prescription",	Число(Выборка.ОтпускПоРецепту));
			ЗаписьXML.ЗаписатьСтроку("</row>");
		КонецЦикла;
	
	ЗаписьXML.ЗаписатьСтроку("</price_gpart>");
	ЗаписьXML.ЗаписатьСтроку("</document>");
	
	ЗаписьXML.Закрыть();
	ЗаписьXML = Новый ЧтениеТекста(ИмяФайла,"windows-1251");
	ВесьТекст = ЗаписьXML.Прочитать();
	ЗаписьXML.Закрыть();
	УдалитьФайлы(ИмяФайла);
	
	//Получение кода заменено на тригер в БД tr_InfoRg6145_bi
	//КодСчетчика = ОМ_ТСО.ПолучитьКодСчетчика("ОбменАптекаОфисЦелевые");
	//Если КодСчетчика = -1 Тогда
	//	КодСчетчика = ОМ_ТСО.ПолучитьКодСчетчика("ОбменАптекаОфисЦелевые");
	//	Если КодСчетчика = -1 Тогда
	//		Возврат;	
	//	КонецЕсли;
	//КонецЕсли;
	
	МЗ = РегистрыСведений.ОфисАптекаЦелевые.СоздатьМенеджерЗаписи();
	МЗ.Код = 1;
	МЗ.КодАптеки = Склад.Код;
	МЗ.ТипУпаковки = "PRICE_GPART";
	МЗ.Приоритет = 1;
	МЗ.ВерсияФормата = 1;
	МЗ.ИмяФайла = "price_gpart_" + СокрЛП(Формат(Склад.Код,"ЧГ=0")) + "_" + Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy.ЧЧ.мм.сс") +".xml";
	МЗ.ИдентификаторКодировки = 1;
	МЗ.ХМЛСтрока = ВесьТекст;
	МЗ.Записать();		
	
КонецПроцедуры

Процедура УстановитьОбщиеЦены(Выборка)
	
	СкладКод = Склад.Код;
	ТекДата = ТекущаяДата();
	Пока Выборка.Следующий() Цикл
		МЗ = РегистрыСведений.РозничныеЦены.СоздатьМенеджерЗаписи();
		МЗ.АптекаКод = СкладКод;
		МЗ.ТоварКод = Выборка.КодТовара;
		МЗ.ДатаУстановки =  ТекДата;
		МЗ.Цена = Выборка.Цена;
		МЗ.Коэффициент = Выборка.КоэффициентРазбивки;
		МЗ.СтавкаНДС = Выборка.СтавкаНДС;
		МЗ.Документ = Ссылка;
		МЗ.НомерДокумента = Номер;
		МЗ.Записать();
		Если ОтложенныеЦены Тогда
			МЗ2 = РегистрыСведений.РозничныеЦеныОтложенные.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МЗ2,МЗ);
			МЗ2.Записать();
		Иначе
			РЦО = РегистрыСведений.РозничныеЦеныОтложенные.СоздатьМенеджерЗаписи();
			РЦО.АптекаКод = СкладКод;
			РЦО.ТоварКод = Выборка.КодТовара;
			РЦО.Прочитать();
			Если РЦО.Выбран() Тогда
				ЗаполнитьЗначенияСвойств(РЦО,МЗ);
				РЦО.Записать();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьИндивидуальныеЦены(Выборка)
	
	
	СкладКод = Склад.Код;
	ТекДата = ТекущаяДата();
	Пока Выборка.Следующий() Цикл
		МЗ = РегистрыСведений.РозничныеЦеныПоПартиям.СоздатьМенеджерЗаписи();
		МЗ.АптекаКод = СкладКод;
		МЗ.ТоварКод = Выборка.КодТовара;
		МЗ.ПартияКод = Выборка.КодПартии;
		МЗ.ДатаУстановки =  ТекДата;
		МЗ.Цена = Выборка.Цена;
		МЗ.Коэффициент = Выборка.КоэффициентРазбивки;
		МЗ.СтавкаНДС = Выборка.СтавкаНДС;
		МЗ.Документ = Ссылка;
		МЗ.НомерДокумента = Номер;
		МЗ.Уценка = Выборка.Уценка;
		МЗ.Записать();
		Если ОтложенныеЦены Тогда
			МЗ2 = РегистрыСведений.РозничныеЦеныПоПартиямОтложенные.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МЗ2,МЗ);
			МЗ2.Записать();
		Иначе
			РЦО = РегистрыСведений.РозничныеЦеныПоПартиямОтложенные.СоздатьМенеджерЗаписи();
			РЦО.АптекаКод = СкладКод;
			РЦО.ТоварКод = Выборка.КодТовара;
			РЦО.ПартияКод = Выборка.КодПартии;
			РЦО.Прочитать();
			Если РЦО.Выбран() Тогда
				ЗаполнитьЗначенияСвойств(РЦО,МЗ);
				РЦО.Записать();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры



Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	
	//Если Склад.АптекаНаНовомПО Тогда
	    ПровестиДляНовогоПО(Отказ);
		ОбщегоНазначения.ЗаписатьИсториюИзмененияДокумента(Ссылка,"Установка цен",ПараметрыСеанса.ТекущийСотр,"Установка новых цен");
		Если НЕ ОтложенныеЦены Тогда
			ОбщегоНазначения.ЗаписатьИсториюИзмененияДокумента(Ссылка,"Выгрузка",ПараметрыСеанса.ТекущийСотр,"Выгружен в новый формат");
		КонецЕсли;
	//Иначе
	//	ПровестиДляСтарогоПО(Отказ);
	//	ОбщегоНазначения.ЗаписатьИсториюИзмененияДокумента(Ссылка,"Установка цен",ПараметрыСеанса.ТекущийСотр,"Установка новых цен");
	//	ОбщегоНазначения.ЗаписатьИсториюИзмененияДокумента(Ссылка,"Выгрузка",ПараметрыСеанса.ТекущийСотр,"Выгружен в старый формат");
	//КонецЕсли;
	
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//Если Проведен и РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
	//	#Если Клиент Тогда
	//		Предупреждение("Из этого документ уже проводилась установка цен. Выполнение не может быть продолжено");
	//	#КонецЕсли
	//	Отказ = истина;
	//КонецЕсли;
	Если  РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	УстановкаРозничныхЦенТовар.КодТовара,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ УстановкаРозничныхЦенТовар.ЦенаОбщаяНовая) КАК КоличествоЦен
		|ИЗ
		|	Документ.УстановкаРозничныхЦен.Товар КАК УстановкаРозничныхЦенТовар
		|ГДЕ
		|	УстановкаРозничныхЦенТовар.Ссылка = &Ссылка
		|	И УстановкаРозничныхЦенТовар.ЦенаОбщаяНовая > 0
		|	И УстановкаРозничныхЦенТовар.ЦенаОбщаяНовая <> УстановкаРозничныхЦенТовар.ЦенаОбщая
		|
		|СГРУППИРОВАТЬ ПО
		|	УстановкаРозничныхЦенТовар.КодТовара
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ УстановкаРозничныхЦенТовар.ЦенаОбщаяНовая) > 1";
		
		Запрос.УстановитьПараметр("Ссылка",Ссылка);			   
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			#Если Клиент Тогда
				Выборка = Результат.Выбрать();
				Пока Выборка.Следующий() Цикл
					Сообщить("По коду товара: " + Формат(Выборка.КодТовара,"ЧГ=0") + " есть разные общие цены. Применение цен не может быть продолжено.");
				КонецЦикла;
			#КонецЕсли
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		Автор = ПараметрыСеанса.ТекущийСотр;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() Тогда
		ОбщегоНазначения.ЗаписатьСменуСостоянияДокумента(Ссылка,РежимЗаписи,ПометкаУдаления);
	КонецЕсли;
	
КонецПроцедуры




