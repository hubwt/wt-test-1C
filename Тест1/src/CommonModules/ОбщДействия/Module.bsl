Процедура ПоискКодаНаСайте(кодтовара) Экспорт
	// Вставить содержимое обработчика.
	код = Число(кодтовара);     
	ссылка = "https://worktruck.ru/search?keywords="+Формат("00"+код,"ЧЦ=8; ЧГ=0");
	ЗапуститьПриложение(ссылка);
КонецПроцедуры



Процедура ОткрытьДетальНаСайте(ИндКод) Экспорт

	///+ГомзМА 20.12.2023
	Ссылка = "https://10.wt10.ru/product/" + ИндКод;
	ЗапуститьПриложение(Ссылка);
	///-ГомзМА 20.12.2023

КонецПроцедуры
