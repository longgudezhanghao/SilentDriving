package com.dzf.service.imp;

import com.dzf.mapper.PersonMapper;
import com.dzf.pojo.Person;
import com.dzf.service.PersonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("peopleService")
public class PersonServiceImp implements PersonService {

    @Autowired
    private PersonMapper personMapper;

    @Override
    public void registerPeopleo(Person person) {

        personMapper.registerPeople(person);

    }
}
