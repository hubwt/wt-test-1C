
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("", );
	ПараметрыФормы.Вставить("Менеджер", ПолучитьМенеджера());
	ОткрытьФорму("Документ.ЗаказКлиента.Форма.ФормаСпискаАктуальныеПоМенеджерам1", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецПроцедуры


Функция ПолучитьМенеджера()
Возврат Справочники.Пользователи.НайтиПоНаименованию("Алексеев Никита Игоревич");
КонецФункции
