Процедура ПоискАртикулаНаНовомСайте(Артикул) Экспорт
	/// Комлев 21/05/24 +++
	Артикул = СтрЗаменить(Артикул," " , "" );     
	Ссылка = "https://wt10.ru/home?text="+ Артикул;
	ЗапуститьПриложение(Ссылка);
	/// Комлев 21/05/24 ---
КонецПроцедуры



Процедура ОткрытьДетальНаСайте(ИндКод) Экспорт

	///+ГомзМА 20.12.2023
	Ссылка = "https://10.wt10.ru/product/" + ИндКод;
	ЗапуститьПриложение(Ссылка);
	///-ГомзМА 20.12.2023

КонецПроцедуры

Процедура ПоискКодаНаСтаромСайте(Код) Экспорт
	Код = СокрЛП(Код);     
 	Ссылка = "https://worktruck.ru/search?keywords="+Формат("00"+Код,"ЧЦ=8; ЧГ=0");
	ЗапуститьПриложение(ссылка);
КонецПроцедуры

Процедура ОткрытьДетальНаСайтеСписком(ИндКод) Экспорт
	/// Комлев 22/05/24 +++
	
	Ссылка = "https://10.wt10.ru/catalog?text=" + Прав(ИндКод, 6) + "&page=1&category=3";
	ЗапуститьПриложение(Ссылка);
	/// Комлев 22/05/24 +++
КонецПроцедуры