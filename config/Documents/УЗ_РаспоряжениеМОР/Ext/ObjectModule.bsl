﻿
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
		ЗаписьXML.ДобавитьСтроку("<" + Имя + "/>");
	Иначе
		ЗаписьXML.ДобавитьСтроку("<" + Имя + ">" + Значение + "</" + Имя + ">");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьНачалоЭлемента(ЗаписьXML,Имя)
	
	ЗаписьXML.ДобавитьСтроку("<" + Имя + ">");
	
КонецПроцедуры

Процедура ЗаписатьКонецЭлемента(ЗаписьXML,Имя)
	
	ЗаписьXML.ДобавитьСтроку("</" + Имя + ">");
	
КонецПроцедуры

Процедура ДобавитьСекциюКонтрагента(ЗаписьXML)
	
	
	Контрагент = Поставщик;
	КодКонтрагента =  Формат(Контрагент.Код,"ЧГ=0");
	
	СчетКонтрагента = Контрагент.ОсновнойСчет;
	КодСчетаКонтрагента = СчетКонтрагента.Код;
	КодБанка = СчетКонтрагента.Банк.Код; 
	
	ЕстьСчет = Истина;
	Если СчетКонтрагента = Неопределено или СчетКонтрагента.Пустая() или КодСчетаКонтрагента = Неопределено Тогда
		ЕстьСчет = ЛОЖЬ;
	КонецЕсли;
	
	Если ЕстьСчет Тогда
		ЗаписьXML.ДобавитьСтроку("<bank>");
			ЗаписьXML.ДобавитьСтроку("<row>");
				   ЗаписатьЭлементXML(ЗаписьXML, "id",	Формат(КодБанка,"ЧГ=0; ЧН=0") );				
				   ЗаписатьЭлементXML(ЗаписьXML, "bic",	Формат(КодБанка,"ЧГ=0; ЧН=0") );				
				   ЗаписатьЭлементXML(ЗаписьXML, "is_deleted", "0"); 
				   ЗаписатьЭлементXML(ЗаписьXML, "descr",		КорректировкаСпецСимволов(СокрЛП(СчетКонтрагента.Банк.Наименование)));
				   ЗаписатьЭлементXML(ЗаписьXML, "corr_acc",	СокрЛП(СчетКонтрагента.Банк.КоррСчет));
			ЗаписьXML.ДобавитьСтроку("</row>");
		ЗаписьXML.ДобавитьСтроку("</bank>"); //конец записи секции  "bank"
		
		ЗаписьXML.ДобавитьСтроку("<bank_account>");
			ЗаписьXML.ДобавитьСтроку("<row>");
				   ЗаписатьЭлементXML(ЗаписьXML, "id",				Формат(Число(СокрЛП(КодСчетаКонтрагента)),"ЧГ=0") );				
				   ЗаписатьЭлементXML(ЗаписьXML, "is_deleted", "0"); 
				   ЗаписатьЭлементXML(ЗаписьXML, "descr",			КорректировкаСпецСимволов(СокрЛП(СчетКонтрагента.Наименование)));
				   ЗаписатьЭлементXML(ЗаписьXML, "num",				СокрЛП(СчетКонтрагента.НомерСчета));
				   ЗаписатьЭлементXML(ЗаписьXML, "id_contragent",	КодКонтрагента);
				   ЗаписатьЭлементXML(ЗаписьXML, "id_bank",			Формат(КодБанка,"ЧГ=0; ЧН=0"));
			ЗаписьXML.ДобавитьСтроку("</row>");
		ЗаписьXML.ДобавитьСтроку("</bank_account>"); //конец записи секции  "bank"		
	КонецЕсли;			
	
		ЗаписьXML.ДобавитьСтроку("<contragent>");
			ЗаписьXML.ДобавитьСтроку("<row>");
				 ЗаписатьЭлементXML(ЗаписьXML, "id", КодКонтрагента); 			
			     ЗаписатьЭлементXML(ЗаписьXML, "is_deleted", ""+Число(Контрагент.ПометкаУдаления));
				 ЗаписатьЭлементXML(ЗаписьXML, "is_internal", ""+Число(Контрагент.Внутренний));
				 ЗаписатьЭлементXML(ЗаписьXML, "descr",	КорректировкаСпецСимволов(СокрЛП(Контрагент.ПолнНаименование))); 
				 ЗаписатьЭлементXML(ЗаписьXML, "sdescr",КорректировкаСпецСимволов(СокрЛП(Контрагент.Наименование)));
				 ЗаписатьЭлементXML(ЗаписьXML, "inn",	КорректировкаСпецСимволов(СокрЛП(Контрагент.ИНН)));
				 ЗаписатьЭлементXML(ЗаписьXML, "kpp",	КорректировкаСпецСимволов(СокрЛП(Контрагент.КПП)));
				 ЗаписатьЭлементXML(ЗаписьXML, "ogrn",	КорректировкаСпецСимволов(СокрЛП(Контрагент.ОГРН)));
				 ЗаписатьЭлементXML(ЗаписьXML, "okpo",	КорректировкаСпецСимволов(СокрЛП(Контрагент.ОКПО)));
				 ЗаписатьЭлементXML(ЗаписьXML, "addr_u",	КорректировкаСпецСимволов(СокрЛП(Контрагент.Адрес)));
				 ЗаписатьЭлементXML(ЗаписьXML, "addr_f",	КорректировкаСпецСимволов(СокрЛП(Контрагент.АдресГрузополучателя)));
				 Если ЕстьСчет Тогда
				 	ЗаписатьЭлементXML(ЗаписьXML, "id_bank_account", Формат(Число(СокрЛП(КодСчетаКонтрагента)),"ЧГ=0") );
				 Иначе
					ЗаписатьЭлементXML(ЗаписьXML, "id_bank_account", "0" );
				 КонецЕсли;
				 ЗаписатьЭлементXML(ЗаписьXML, "type_tax", "" + Число(Контрагент.КонтрагентНаУСН)); 
				 ЗаписатьЭлементXML(ЗаписьXML, "e_mail", ""); 
				 ЗаписатьЭлементXML(ЗаписьXML, "phone", "");
				 ЗаписатьЭлементXML(ЗаписьXML, "director", "");
				 ЗаписатьЭлементXML(ЗаписьXML, "bookkeeper", "");
			ЗаписьXML.ДобавитьСтроку("</row>");
		ЗаписьXML.ДобавитьСтроку("</contragent>"); //конец записи секции  "contragent"
	
КонецПроцедуры

Процедура ДобавитьСекциюКомитент(ЗаписьXML)
	Контрагент = ПоставщикКомитент;
	КодКонтрагента =  Формат(Контрагент.Код,"ЧГ=0");
	
	ЗаписьXML.ДобавитьСтроку("<contragent_comitant>");
	ЗаписьXML.ДобавитьСтроку("<row>");
	ЗаписатьЭлементXML(ЗаписьXML, "id", КодКонтрагента); 			
	ЗаписатьЭлементXML(ЗаписьXML, "is_deleted", ""+Число(Контрагент.ПометкаУдаления));
	ЗаписатьЭлементXML(ЗаписьXML, "is_internal", ""+Число(Контрагент.Внутренний));
	ЗаписатьЭлементXML(ЗаписьXML, "descr",	КорректировкаСпецСимволов(СокрЛП(Контрагент.ПолнНаименование))); 
	ЗаписатьЭлементXML(ЗаписьXML, "sdescr",КорректировкаСпецСимволов(СокрЛП(Контрагент.Наименование)));
	ЗаписатьЭлементXML(ЗаписьXML, "inn",	КорректировкаСпецСимволов(СокрЛП(Контрагент.ИНН)));
	ЗаписатьЭлементXML(ЗаписьXML, "kpp",	КорректировкаСпецСимволов(СокрЛП(Контрагент.КПП)));
	ЗаписатьЭлементXML(ЗаписьXML, "ogrn",	КорректировкаСпецСимволов(СокрЛП(Контрагент.ОГРН)));
	ЗаписатьЭлементXML(ЗаписьXML, "okpo",	КорректировкаСпецСимволов(СокрЛП(Контрагент.ОКПО)));
	ЗаписатьЭлементXML(ЗаписьXML, "addr_u",	КорректировкаСпецСимволов(СокрЛП(Контрагент.Адрес)));
	ЗаписатьЭлементXML(ЗаписьXML, "addr_f",	КорректировкаСпецСимволов(СокрЛП(Контрагент.АдресГрузополучателя)));
	ЗаписатьЭлементXML(ЗаписьXML, "type_tax", "" + Число(Контрагент.КонтрагентНаУСН)); 
	ЗаписатьЭлементXML(ЗаписьXML, "e_mail", ""); 
	ЗаписатьЭлементXML(ЗаписьXML, "phone", "");
	ЗаписатьЭлементXML(ЗаписьXML, "director", "");
	ЗаписатьЭлементXML(ЗаписьXML, "bookkeeper", "");
	ЗаписьXML.ДобавитьСтроку("</row>");
	ЗаписьXML.ДобавитьСтроку("</contragent_comitant>"); //конец записи секции  "contragent_comitant"
	
КонецПроцедуры
	
Процедура ДобавитьСекциюТоваров(ЗаписьXML)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	Выборка.Товар,
	               |	Выборка.Товар.ПометкаУдаления КАК ПометкаУдаления,
	               |	Выборка.Товар.Код КАК КодТовара,
	               |	Выборка.Товар.Наименование КАК Наименование,
	               |	ПОДСТРОКА(Выборка.Товар.МеждународноеНазвание, 1, 150) КАК МеждународноеНазвание,
	               |	0 КАК КодПроизводителя,
	               |	Выборка.Товар.УчаствуетВАП КАК УчаствуетВАП,
	               |	ЕСТЬNULL(Выборка.Товар.МНН.Код, 0) КАК КодМНН,
	               |	Выборка.Товар.ЖНВЛС КАК ЖНВЛС,
	               |	Выборка.Товар.ПККН КАК ПККН,
	               |	ВЫБОР
	               |		КОГДА Выборка.Товар.ДатаВводаВАП = ДАТАВРЕМЯ(1, 1, 1)
	               |			ТОГДА ДАТАВРЕМЯ(2000, 1, 1)
	               |		ИНАЧЕ Выборка.Товар.ДатаВводаВАП
	               |	КОНЕЦ КАК ДатаВводаВАП,
	 		  	   // НДС20/18 
	               //|	Выборка.Товар.СтавкаНДС.Ставка КАК Ставка,
			 	   |	ВЫБОР
			       |		КОГДА Выборка.Товар.СтавкаНДС.Код = 3
			  	   |				И Выборка.Ссылка.Дата < ДАТАВРЕМЯ(2019, 1, 1)
			  	   |			ТОГДА 18
			  	   |		ИНАЧЕ Выборка.Товар.СтавкаНДС.Ставка
			 	   |	КОНЕЦ КАК Ставка,
	               |	Выборка.Товар.АптечныйОБ КАК ОбязательноеНаличие,
	               |	Выборка.Товар.МаксКоличествоВОдинЧек КАК МаксКоличествоВОдинЧек,
	               |	Выборка.Товар.ОтпускПоРецепту КАК ОтпускПоРецепту,
	               |	ЕСТЬNULL(Выборка.Товар.Подкатегория.Код, 0) КАК КодПодкатегории,
	               |	Выборка.КоэффициентРазбивки,
				   |	ЕСТЬNULL(Выборка.Товар.Страна.Наименование,"""") как Страна
	               |ИЗ
	               |	Документ.УЗ_РаспоряжениеМОР.Товар КАК Выборка
	               |ГДЕ
	               |	Выборка.Ссылка = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ЕСТЬNULL(Выборка.Товар.МНН.Код, 0) КАК КодМНН,
	               |	ЕСТЬNULL(Выборка.Товар.МНН.Наименование, """") КАК НаименованиеМНН
	               |ИЗ
	               |	Документ.УЗ_РаспоряжениеМОР.Товар КАК Выборка
	               |ГДЕ
	               |	Выборка.Ссылка = &Ссылка
	               |	И ЕСТЬNULL(Выборка.Товар.МНН.Код, 0) > 0";
				   
			Запрос.УстановитьПараметр("Ссылка",Ссылка);

			Результат				= Запрос.ВыполнитьПакет();	   
			ВыборкаТовары			= Результат[0].Выбрать();				   
			ВыборкаМНН				= Результат[1].Выбрать();
			
		ЗаписьXML.ДобавитьСтроку("<inter_name>");
			Пока ВыборкаМНН.Следующий() Цикл
				ЗаписьXML.ДобавитьСтроку("<row>");
				   ЗаписатьЭлементXML(ЗаписьXML, "id",	Формат(ВыборкаМНН.КодМНН,"ЧГ=0; ЧН=0") );				
				   ЗаписатьЭлементXML(ЗаписьXML, "is_deleted", "0"); 
				   ЗаписатьЭлементXML(ЗаписьXML, "descr",		КорректировкаСпецСимволов(СокрЛП(ВыборкаМНН.НаименованиеМНН)));
				   ЗаписатьЭлементXML(ЗаписьXML, "sname",		"");
				ЗаписьXML.ДобавитьСтроку("</row>");
			КонецЦикла;
		ЗаписьXML.ДобавитьСтроку("</inter_name>"); //конец записи секции  "mnn"
		
		ЗаписьXML.ДобавитьСтроку("<goods>");
			Пока ВыборкаТовары.Следующий() Цикл
				ЗаписьXML.ДобавитьСтроку("<row>");
				  ЗаписатьЭлементXML(ЗаписьXML, "id",			Формат(ВыборкаТовары.КодТовара,"ЧГ=0"));
				  ЗаписатьЭлементXML(ЗаписьXML, "is_deleted",	"" + Число(ВыборкаТовары.ПометкаУдаления)); 
				  ЗаписатьЭлементXML(ЗаписьXML, "is_active",	"" + Число(ВыборкаТовары.УчаствуетВАП));
				  ЗаписатьЭлементXML(ЗаписьXML, "descr",		КорректировкаСпецСимволов(СокрЛП(ВыборкаТовары.Наименование)));
				  ЗаписатьЭлементXML(ЗаписьXML, "descr_ecr",	"");
				  ЗаписатьЭлементXML(ЗаписьXML, "descr_en",		КорректировкаСпецСимволов(СокрЛП(ВыборкаТовары.МеждународноеНазвание)));
				  ЗаписатьЭлементXML(ЗаписьXML, "article",		""); 
				  ЗаписатьЭлементXML(ЗаписьXML, "p_vat",		Формат(ВыборкаТовары.Ставка,"ЧГ=0; ЧН=0")); 
				  ЗаписатьЭлементXML(ЗаписьXML, "id_group_ap",	"0"); 
				  ЗаписатьЭлементXML(ЗаписьXML, "id_group_ftg",	"0"); 
				  ЗаписатьЭлементXML(ЗаписьXML, "id_group_main","0"); //основная группа
				  ЗаписатьЭлементXML(ЗаписьXML, "id_group_general","0"); //обобщенная группа
				  ЗаписатьЭлементXML(ЗаписьXML, "id_brand_goods","0"); 
				  ЗаписатьЭлементXML(ЗаписьXML, "id_trade_name","0"); 
				  ЗаписатьЭлементXML(ЗаписьXML, "id_inter_name",Формат(ВыборкаТовары.КодМНН,"ЧГ=0; ЧН=0")); 
				  ЗаписатьЭлементXML(ЗаписьXML, "id_category_goods","0"); 
				  ЗаписатьЭлементXML(ЗаписьXML, "id_sub_category_goods",Формат(ВыборкаТовары.КодПодкатегории,"ЧГ=0; ЧН=0")); 
				  ЗаписатьЭлементXML(ЗаписьXML, "id_med_form",	"0"); 
				  ЗаписатьЭлементXML(ЗаписьXML, "id_destination","0"); 
				  ЗаписатьЭлементXML(ЗаписьXML, "id_prod_form",	"0"); 
				  ЗаписатьЭлементXML(ЗаписьXML, "id_storing_place","0"); 
				  ЗаписатьЭлементXML(ЗаписьXML, "is_life_important","" + Формат(Число(ВыборкаТовары.ЖНВЛС),"ЧН=0"));  
				  ЗаписатьЭлементXML(ЗаписьXML, "is_social_important","0"); 
				  ЗаписатьЭлементXML(ЗаписьXML, "is_scdc_list",		"" + Формат(Число(ВыборкаТовары.ПККН),"ЧН=0")); 
				  ЗаписатьЭлементXML(ЗаписьXML, "is_mandatory",		"" + Формат(Число(ВыборкаТовары.ОбязательноеНаличие),"ЧН=0")); 
				  ЗаписатьЭлементXML(ЗаписьXML, "is_prescription","" + Формат(Число(ВыборкаТовары.ОтпускПоРецепту),"ЧН=0")); 
				  ЗаписатьЭлементXML(ЗаписьXML, "date_in", 		Формат(ВыборкаТовары.ДатаВВодаВАП,"ДФ=dd.MM.yyyy")); 
				  ЗаписатьЭлементXML(ЗаписьXML, "producer_country_descr",		КорректировкаСпецСимволов(СокрЛП(ВыборкаТовары.Страна)));
				  //ЗаписатьЭлементXML(ЗаписьXML, "id_group",		"0"); 
				  //ЗаписатьЭлементXML(ЗаписьXML, "is_season",	"0"); 
				  //ЗаписатьЭлементXML(ЗаписьXML, "id_exclusive_post","0"); 
				  //ЗаписатьЭлементXML(ЗаписьXML, "id_unit",		"0");
				  //ЗаписатьЭлементXML(ЗаписьXML, "cost_r",		Формат(ВыборкаТовары.РозничнаяЦена,"ЧРД=.; ЧН=0; ЧГ=0")); 
				  //ЗаписатьЭлементXML(ЗаписьXML, "cost_i",		"0"); 
				  //ЗаписатьЭлементXML(ЗаписьXML, "min_part_ship","0"); 
				  //ЗаписатьЭлементXML(ЗаписьXML, "min_qnt",		"0"); 
				  //ЗаписатьЭлементXML(ЗаписьXML, "max_qnt",		"0"); 
				  //ЗаписатьЭлементXML(ЗаписьXML, "is_discount",	"0"); 
				  //ЗаписатьЭлементXML(ЗаписьXML, "p_discount",	"0"); 
				  //ЗаписатьЭлементXML(ЗаписьXML, "max_qnt_sale",	Формат(ВыборкаТовары.МаксКоличествоВОдинЧек,"ЧГ=0; ЧН=0"));
				  //ЗаписатьЭлементXML(ЗаписьXML, "is_course",	"0");
				  //ЗаписатьЭлементXML(ЗаписьXML, "course_qnt",	"0"); 
				  //ЗаписатьЭлементXML(ЗаписьXML, "min_part_dem",	"0"); 
				ЗаписьXML.ДобавитьСтроку("</row>");
			КонецЦикла;
		ЗаписьXML.ДобавитьСтроку("</goods>"); //конец записи секции  "good"
			
			
	
КонецПроцедуры


Функция ВыгрузитьВАптеку() Экспорт
	
	Если НЕ проведен и НЕ ( Статус = Перечисления.СтатусыСписания.Аннулирован или Статус = Перечисления.СтатусыСписания.СогласованиеОтменено) Тогда
		#Если Клиент Тогда
			Предупреждение("Документ не проведен. Выполнение не может быть продолжено");
		#КонецЕсли
		Возврат Ложь;
	КонецЕсли;
			

	ЗаписьXML = Новый ТекстовыйДокумент;
	
	
	ЗаписьXML.ДобавитьСтроку("<?xml version=""1.0"" encoding=""WINDOWS-1251""?>");

	ЗаписьXML.ДобавитьСтроку("<document>"); 

	
	ЗаписатьЭлементXML(ЗаписьXML, "pack_type", "OUT_SMALL_WH_SALE_ORDER"); 
	ЗаписатьЭлементXML(ЗаписьXML, "fmt_ver", "1"); 
	
	ДобавитьСекциюКонтрагента(ЗаписьXML);
	ДобавитьСекциюТоваров(ЗаписьXML);
	ДобавитьСекциюКомитент(ЗаписьXML);	
	ЗаписьXML.ДобавитьСтроку("<hdr>");
		ЗаписатьЭлементXML(ЗаписьXML, "id_doc_type", 	"222"); 
		ЗаписатьЭлементXML(ЗаписьXML, "id_doc_subtype", 	Перечисления.ВидыОперацийМелкооптовойРеализации.Индекс(ВидОперацииМелкооптовойРеализации)); 
		ЗаписатьЭлементXML(ЗаписьXML, "guid",	ИДДокументаАптеки); 
		ЗаписатьЭлементXML(ЗаписьXML, "ndoc",		Формат(Номер,"ЧГ=0")); 
		ЗаписатьЭлементXML(ЗаписьXML, "ddoc",	Формат(Дата,"ДФ=dd.MM.yyyy"));
		ЗаписатьЭлементXML(ЗаписьXML, "id_contragent", Поставщик.Код);
		ЗаписатьЭлементXML(ЗаписьXML, "price_calc_algorythm", 	Перечисления.АлгоритмРасценкиВМОР.Индекс(АлгоритмРасценки)); 		
		ЗаписатьЭлементXML(ЗаписьXML, "gpart_selection_algorithm", 	Перечисления.АлгоритмПодбораПартийВМОР.Индекс(АлгоритмПодбораПартий)); 		
		Если Статус = Перечисления.СтатусыСписания.Согласован Тогда
			ЗаписатьЭлементXML(ЗаписьXML, "status",	Перечисления.СтатусДокАптеки.Индекс(Перечисления.СтатусДокАптеки.Создан)); 
		ИначеЕсли Статус = Перечисления.СтатусыСписания.Аннулирован Тогда
			ЗаписатьЭлементXML(ЗаписьXML, "status",	Перечисления.СтатусДокАптеки.Индекс(Перечисления.СтатусДокАптеки.Аннулирован)); 
		Иначе
			ЗаписатьЭлементXML(ЗаписьXML, "status",	Перечисления.СтатусДокАптеки.Индекс(Перечисления.СтатусДокАптеки.Создан)); 
		КонецЕсли;
		ЗаписатьЭлементXML(ЗаписьXML, "dsc_office", 		КорректировкаСпецСимволов(СокрЛП(Комментарий)));	
		
		ЗаписьXML.ДобавитьСтроку("<Delivery_type>");
		ЗаписьXML.ДобавитьСтроку("<row>");
		ЗаписатьЭлементXML(ЗаписьXML, "id",	Формат(ТипПоставки.Код,"ЧГ=0; ЧН=0") );
		ЗаписатьЭлементXML(ЗаписьXML, "descr",КорректировкаСпецСимволов(СокрЛП(ТипПоставки.Наименование)));
		ЗаписатьЭлементXML(ЗаписьXML, "is_deleted",	"" + Число(ТипПоставки.ПометкаУдаления));
		ЗаписатьЭлементXML(ЗаписьXML, "id_warehouse_acceptance",	Формат(ТипПоставки.КодСкладаПриемки,"ЧГ=0; ЧН=0"));
		ЗаписатьЭлементXML(ЗаписьXML, "descr_warehouse_acceptance",КорректировкаСпецСимволов(СокрЛП(ТипПоставки.НаименованиеСкладаПриемки)));
		ЗаписьXML.ДобавитьСтроку("</row>");
		ЗаписьXML.ДобавитьСтроку("</Delivery_type>"); //конец записи секции  "Delivery_type"
		ЗаписатьЭлементXML(ЗаписьXML, "id_contragent_comitant", Формат(ПоставщикКомитент.Код,"ЧГ=0; ЧН=0"));
		Если НЕ УровеньКонтроляУПД_МОР.Пустая() Тогда
			ЗаписатьЭлементXML(ЗаписьXML, "level_control_UPD_MOR", 	Перечисления.УровеньКонтроляУПД_МОР.Индекс(УровеньКонтроляУПД_МОР));
		КонецЕсли;	
		ЗаписатьЭлементXML(ЗаписьXML, "prohibition_of_excess_quantities",	"" + Число(ЗапретПревышенияКоличества));
		//==> ЕНТ-1466.Коробка.2019.03.18
		// Новое поле в посылке
		ЗаписатьЭлементXML(ЗаписьXML, "wave_name", 		КорректировкаСпецСимволов(СокрЛП(Волна.Наименование)));	
		//<== ЕНТ-1466.Коробка.2019.03.18
		
  	ЗаписьXML.ДобавитьСтроку("</hdr>"); //конец записи секции  "hdr"
	
	ЗаписьXML.ДобавитьСтроку("<str>");
	Для каждого стр из Товар Цикл
		ЗаписьXML.ДобавитьСтроку("<row>");
			ЗаписатьЭлементXML(ЗаписьXML, "id_goods"	,Формат(стр.КодТовара,"ЧГ=0; ЧН=0"));
			ЗаписатьЭлементXML(ЗаписьXML, "qnt"			,Формат(стр.Количество,"ЧГ=0; ЧН=0"));
			ЗаписатьЭлементXML(ЗаписьXML, "coeff"		,"1");
			ЗаписатьЭлементXML(ЗаписьXML, "sum_pay"		,Формат(стр.СуммаРеализации,"ЧРД=.; ЧН=0; ЧГ=0"));
			ЗаписатьЭлементXML(ЗаписьXML, "sum_pay_vat"	,Формат(стр.СуммаНДСРеализации,"ЧРД=.; ЧН=0; ЧГ=0"));
			ЗаписатьЭлементXML(ЗаписьXML, "id_part"		,Формат(стр.КодПартии,"ЧГ=0; ЧН=0"));
		ЗаписьXML.ДобавитьСтроку("</row>");
	КонецЦикла;
	
	ЗаписьXML.ДобавитьСтроку("</str>");

	ЗаписьXML.ДобавитьСтроку("</document>"); //конец записи секции  "document"
	ВесьТекст = ЗаписьXML.ПолучитьТекст();
	
	ЗаписьXML.Очистить();
	ЗаписьXML = Неопределено;
	
	КодСклада = Склад.Код;
	КодСчетчика = ОМ_ТСО.ПолучитьКодСчетчика("ОбменАптекаОфисЦелевые");
	Если КодСчетчика = -1 Тогда
		КодСчетчика = ОМ_ТСО.ПолучитьКодСчетчика("ОбменАптекаОфисЦелевые");
		Если КодСчетчика = -1 Тогда
			Возврат Ложь;	
		КонецЕсли;
	КонецЕсли;
	
	//к = Число("раздватри");
	
	МЗ = РегистрыСведений.ОфисАптекаЦелевые.СоздатьМенеджерЗаписи();
	МЗ.Код = КодСчетчика;
	МЗ.КодАптеки = КодСклада;
	МЗ.ТипУпаковки = "OUT_SMALL_WH_SALE_ORDER";
	МЗ.Приоритет = 1;
	МЗ.ВерсияФормата = 1;
	МЗ.ИмяФайла = "out_small_wh_sale_order_" + СокрЛП(Формат(КодСклада,"ЧГ=0")) + "_" + СокрЛП(Формат(Номер,"ЧГ=0")) + "_" + Формат(Дата,"ДФ=dd.MM.yyyy") +".xml";
	МЗ.ИдентификаторКодировки = 1;
	МЗ.ХМЛСтрока = ВесьТекст;
	МЗ.ИдентификаторДокумента = ИДДокументаАптеки;
	МЗ.Записать();	
	
	ОбщегоНазначения.ЗаписатьИсториюИзмененияДокумента(Ссылка,"Выгружен",ПараметрыСеанса.ТекущийСотр,"Выгружен в аптеку");
	
	Возврат Истина;
	
	
КонецФункции

Процедура ПроверитьНаЗаполнение(Отказ)
	
	Если ВидОперацииМелкооптовойРеализации.Пустая() Тогда
		#Если Клиент Тогда
			Сообщить("Не указан вид операции! Документ не проведен",СтатусСообщения.ОченьВажное);	 
		#КонецЕсли	
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Поставщик.Пустая() Тогда
		 #Если Клиент Тогда
			 Сообщить("Не указан поставщик! Документ не проведен",СтатусСообщения.ОченьВажное);	 
		 #КонецЕсли	
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Договор.Пустая() Тогда
		 #Если Клиент Тогда
			 Сообщить("Не указан договор поставщика! Документ не проведен",СтатусСообщения.ОченьВажное);	 
		 #КонецЕсли	
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ТипПоставки.Пустая() Тогда
		 #Если Клиент Тогда
			 Сообщить("Не указан тип поставки на опт. склад! Документ не проведен",СтатусСообщения.ОченьВажное);	 
		 #КонецЕсли	
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(АлгоритмРасценки) Тогда
		 #Если Клиент Тогда
			 Сообщить("Не указан алгоритм расценки! Документ не проведен",СтатусСообщения.ОченьВажное);	 
		 #КонецЕсли	
		Отказ = Истина;
		Возврат;
	КонецЕсли;	


	Если АлгоритмРасценки = Перечисления.АлгоритмРасценкиВМОР.РучнойВводЦены Тогда
		Если НЕ Товар.Найти(0,"ЦенаЗакупБезНДС") = Неопределено Тогда
			// Есть строки с 0-ми
			#Если Клиент Тогда
				Сообщить("В документе есть строки без закуп. цены!
				|Это недопустимо!
				|Укажите цену закупочную!");
			#КонецЕсли
			ПроведениеЗакончено=Истина;
			
			Отказ = ИСТИНА;
			Возврат ;
		КонецЕсли;
	КонецЕсли;
	
	//Если ВидОперацииМелкооптовойРеализации = Перечисления.ВидыОперацийМелкооптовойРеализации.ВнешнемуПокупателю
	//	И Поставщик.Код = 3055 Тогда
	//	
	//	// должна быть перекодировка с GDP
	//	Если ЕстьПозицииБезПерекодировки() Тогда
	//		Отказ = Истина;
	//		Возврат;
	//	КонецЕсли;
	//	
	//КонецЕсли;
	Если НЕ ЗначениеЗаполнено(УровеньКонтроляУПД_МОР) Тогда
		 #Если Клиент Тогда
			 Сообщить("Не указан уровень контроля УПД/МОР! Документ не проведен",СтатусСообщения.ОченьВажное);	 
		 #КонецЕсли	
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
КонецПроцедуры

Функция ЕстьПозицииБезПерекодировки()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АП.Код,
	|	АП.Наименование
	|ИЗ
	|	Справочник.АССОРТИМЕНТНЫЙ_ПЛАН КАК АП
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СвязкиТовараСПоставщиком КАК Связки
	|		ПО АП.Ссылка = Связки.ТоварФирмы
	|			И (Связки.Поставщик = &ПоставщикСвязок)
	|			И (Связки.Блокировка = ЛОЖЬ)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СвязкиТовараСПоставщиком КАК СвязкиПоОП
	|		ПО АП.КодОП = СвязкиПоОП.ТоварФирмы.Код
	|			И (СвязкиПоОП.Поставщик = &ПоставщикСвязок)
	|			И (СвязкиПоОП.Блокировка = ЛОЖЬ)
	|ГДЕ
	|	АП.Ссылка В(&Товары)
	|	И Связки.КодТовараПоставщика ЕСТЬ NULL
	|	И СвязкиПоОП.КодТовараПоставщика ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("ПоставщикСвязок", Справочники.Поставщики.НайтиПоКоду(582));
	Запрос.УстановитьПараметр("Товары", Товар.ВыгрузитьКолонку("Товар"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			#Если Клиент Тогда
				ТекстОшибки = "Отсутствует перекодировка с GDP по товару: " 
				+ Формат(Выборка.Код, "ЧГ=0") + " - " + Выборка.Наименование;					
				Сообщить(ТекстОшибки, СтатусСообщения.Важное);
			#КонецЕсли
			
		КонецЦикла;
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции


Процедура ОбработкаПроведения(Отказ, Режим)
	 

	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ДатаПоследнегоИзменения = ТекущаяДата();

	СуммаЗакупБезНДС = Товар.Итог("СуммаЗакупБезНДС");
	СуммаРеализации = Товар.Итог("СуммаРеализации");
	
	Если ЭтоНовый() Тогда
		ДокСсылка = ПолучитьСсылкуНового();	
		Если НЕ ЗначениеЗаполнено(ДокСсылка) Тогда
			ДокСсылка = Документы.УЗ_РаспоряжениеМОР.ПолучитьСсылку();	
			УстановитьСсылкуНового(ДокСсылка);
		КонецЕсли;
		ИДДокументаАптеки = XMLСтрока(ДокСсылка);
	КонецЕсли;	
	
	
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ПроверитьНаЗаполнение(Отказ);	
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		Если СтатусДокАптеки = Перечисления.СтатусДокАптеки.КОбработкеОфисом Тогда
			Статус = Перечисления.СтатусыСписания.Проведен;
		ИначеЕсли СтатусДокАптеки = Перечисления.СтатусДокАптеки.Проведен Тогда
			Статус = Перечисления.СтатусыСписания.Завершен;
		КонецЕсли;

		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ОМ41_ПередУдалениемДокумента  (ЭтотОбъект,Отказ);
		Если Отказ = Истина Тогда
			Возврат;
		КонецЕсли;		
	КонецЕсли;
	
	ОбщегоНазначения.ЗаписатьСменуСостоянияДокумента(Ссылка,РежимЗаписи,ПометкаУдаления);
	
КонецПроцедуры
