﻿Процедура УстановкаПараметровСеанса(ТребуемыеПараметры)
	
   Сотр = Справочники.Сотрудники.НайтиПоРеквизиту("ИмяПользователя",СокрЛП(ИмяПользователя()),);
   
   Если Сотр.Пустая()=Истина Тогда
	   НовыйСотр = Справочники.Сотрудники.СоздатьЭлемент();
	   НовыйСотр.Наименование=СокрЛП(ПолноеИмяПользователя());
	   НовыйСотр.ИмяПользователя=СокрЛП(ИмяПользователя());
	   НовыйСотр.Записать();
	   
	   ПараметрыСеанса.ТекущийСотр=НовыйСотр.Ссылка;
   Иначе
	   ПараметрыСеанса.ТекущийСотр=Сотр;
	КонецЕсли; 
	
	ПараметрыСеанса.ИспользоватьШаблоныОграничения = Истина;
	ПараметрыСеанса.Беспредел=Ложь; 	
	ПараметрыСеанса.РазрешитьДействияВЗакрытомПериоде = ПараметрыСеанса.ТекущийСотр.РазрешитьДействияВЗакрытомПериоде;


	ГУИД=Новый УникальныйИдентификатор;
	
	Слэш = "\";
	Инфо = Новый СистемнаяИнформация;
	Если Инфо.ТипПлатформы = ТипПлатформы.Linux_x86 или 
		Инфо.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
		Слэш = "/";
	КонецЕсли;	
	
	ПараметрыСеанса.КАТАЛОГ_ВРЕМЕННЫХ_ФАЙЛОВ=КаталогВременныхФайлов()+ ГУИД+Слэш;
	
КонецПроцедуры
