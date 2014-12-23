/*
 * Copyright 2014 ivonet
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package nl.ivonet.services;

import nl.ivonet.entities.Person;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import java.net.URI;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import static javax.ws.rs.core.MediaType.APPLICATION_JSON;
import static javax.ws.rs.core.MediaType.APPLICATION_XML;

/**
 * @author Ivo Woltring
 */
@Path("/persons")
public class PersonService {

    private final Map<Integer, Person> dataInMemory;

    public PersonService() {
        this.dataInMemory = new HashMap<>();
        final Person person = new Person();
        person.setId(1);
        person.setName("Ivo");
        person.setLastname("Woltring");
        savePerson(person);
    }

    @POST
    @Produces({APPLICATION_JSON, APPLICATION_XML})
    public Response savePerson(final Person person) {
        final int id = this.dataInMemory.size() + 1;
        person.setId(id);
        this.dataInMemory.put(id, person);
        return Response.created(URI.create("/person/" + id))
                       .build();
    }

    @GET
    @Path("{id}")
    @Produces({APPLICATION_JSON, APPLICATION_XML})
    public Person findById(@PathParam("id") final int id) {
        final Person person = this.dataInMemory.get(id);
        if (person == null) {
            throw new WebApplicationException(Status.NOT_FOUND);
        }
        return person;
    }

    @GET
    @Produces({APPLICATION_JSON, APPLICATION_XML})
    public Collection<Person> get(){
        return dataInMemory.values();
    }
}