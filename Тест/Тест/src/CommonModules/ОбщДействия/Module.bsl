Процедура ПоискКодаНаСайте(Артикул) Экспорт
	// Вставить содержимое обработчика.
	Артикул = СтрЗаменить(Артикул," " , "" );     
	Ссылка = "https://wt10.ru/home?text="+ Артикул;
	ЗапуститьПриложение(Ссылка);
КонецПроцедуры



Процедура ОткрытьДетальНаСайте(ИндКод) Экспорт

	///+ГомзМА 20.12.2023
	Ссылка = "https://10.wt10.ru/product/" + ИндКод;
	ЗапуститьПриложение(Ссылка);
	///-ГомзМА 20.12.2023

КонецПроцедуры
