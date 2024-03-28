
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Ответственный = ТекПользователь();
КонецПроцедуры

&НаСервере
Функция ТекПользователь()
	Пользователь = Пользователи.ТекущийПользователь();
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Сотрудники.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Сотрудники КАК Сотрудники
	               |ГДЕ
	               |	Сотрудники.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь",Пользователь);
	Итог = Запрос.Выполнить().Выбрать();
	Итог.Следующий();
	Возврат Итог.ссылка;				 
КонецФункции
