
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	// Вставить содержимое обработчика.
	ТекДата();
КонецПроцедуры

&НаСервере
Процедура ТекДата()
	Объект.ДатаОбновления = ТекущаяДата();
	Сообщить(Объект.ДатаОбновления);
КонецПроцедуры	
