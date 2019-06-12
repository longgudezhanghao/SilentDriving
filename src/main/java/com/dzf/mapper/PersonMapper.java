package com.dzf.mapper;

import com.dzf.pojo.Person;
import org.apache.ibatis.annotations.Param;

public interface PersonMapper {

    void registerPeople(Person person);

    Integer selectPerson(@Param("name") String name, @Param("password") String password);
}
