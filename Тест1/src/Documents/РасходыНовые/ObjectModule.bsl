
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ЛичныеРасходы Приход
	Движения.ЛичныеРасходы.Записывать = Истина;
	Для Каждого ТекСтрокаТаблица Из Таблица Цикл
		Движение = Движения.ЛичныеРасходы.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.ВидРасхода = ТекСтрокаТаблица.Тип;
		Движение.Комментарий = ТекСтрокаТаблица.Комментарий;
		Движение.ДокНо = ТекСтрокаТаблица.НомерДокумента;
		Движение.Сумма = ТекСтрокаТаблица.Сумма;
	КонецЦикла;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры
