
&НаСервере
Процедура ПрочитатьСообщениеНаСервере()
	Telegram_Сервер.ПрочитатьСообщенияПользователя();
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьСообщение(Команда)
	ПрочитатьСообщениеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗапускОбработчикаОжиданий(Команда)
	 ПодключитьОбработчикОжидания("ОбработчикОжиданияПроцедура",2);
КонецПроцедуры


&НаКлиенте
Процедура ОбработчикОжиданияПроцедура()
	Telegram_Сервер.ПрочитатьСообщенияПользователя();
КонецПроцедуры

&НаСервере
Процедура ОтправитьСообщениеПользователямНаСервере()
	    Запрос = Новый Запрос;
	    Запрос.Текст = "ВЫБРАТЬ
	                   |	Telegram_Пользователи.ИмяПользователяТелеграм КАК ИмяПользователяТелеграм,
	                   |	Telegram_Пользователи.ID_Пользователя КАК ID_Пользователя,
	                   |	Telegram_Пользователи.Пользователь КАК Пользователь
	                   |ИЗ
	                   |	РегистрСведений.Telegram_Пользователи КАК Telegram_Пользователи";
	    
	    ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
	    Пока ВыборкаЗапроса.Следующий() Цикл
	         Telegram_Сервер.ОтправитьСообщениеПользователю(ВыборкаЗапроса.ID_Пользователя,ТекстСогласования);
	    	
	    КонецЦикла;  
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСообщениеПользователям(Команда)
	ОтправитьСообщениеПользователямНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОтправитьСообщениеПользователюНаСервере(Пользователь)
	
	///+ГомзМА 14.03.2024
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Telegram_Пользователи.ИмяПользователяТелеграм КАК ИмяПользователяТелеграм,
	|	Telegram_Пользователи.ID_Пользователя КАК ID_Пользователя,
	|	Telegram_Пользователи.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.Telegram_Пользователи КАК Telegram_Пользователи
	|ГДЕ
	|	Telegram_Пользователи.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
	Пока ВыборкаЗапроса.Следующий() Цикл
		Telegram_Сервер.ОтправитьСообщениеПользователю(ВыборкаЗапроса.ID_Пользователя,ТекстСогласования);
	КонецЦикла;  
	///-ГомзМА 14.03.2024
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСообщениеПользователю(Команда)
	
	///+ГомзМА 14.03.2024
	ОтправитьСообщениеПользователюНаСервере(Пользователь);
	Сообщить("Сообщение отправлено!");
	///-ГомзМА 14.03.2024
	
КонецПроцедуры
