package com.dzf.service;

import com.dzf.pojo.Person;

public interface PersonService {

    void registerPeopleo(Person person);

    Integer selectPerson(String name, String password);
}
