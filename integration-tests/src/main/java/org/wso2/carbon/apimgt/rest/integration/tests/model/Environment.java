/*
 * WSO2 API Manager - Publisher API
 * This specifies a **RESTful API** for WSO2 **API Manager** - Publisher.  Please see [full swagger definition](https://raw.githubusercontent.com/wso2/carbon-apimgt/v6.0.4/components/apimgt/org.wso2.carbon.apimgt.rest.api.publisher/src/main/resources/publisher-api.yaml) of the API which is written using [swagger 2.0](http://swagger.io/) specification. 
 *
 * OpenAPI spec version: 0.10.0
 * Contact: architecture@wso2.com
 *
 * NOTE: This class is auto generated by the swagger code generator program.
 * https://github.com/swagger-api/swagger-codegen.git
 * Do not edit the class manually.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


package org.wso2.carbon.apimgt.rest.integration.tests.model;

import java.util.Objects;
import com.google.gson.annotations.SerializedName;
import io.swagger.annotations.ApiModelProperty;

/**
 * Environment
 */
@javax.annotation.Generated(value = "class io.swagger.codegen.languages.JavaClientCodegen", date = "2016-12-09T04:58:32.531Z")
public class Environment {
  @SerializedName("name")
  private String name = null;

  @SerializedName("type")
  private String type = null;

  @SerializedName("serverUrl")
  private String serverUrl = null;

  @SerializedName("showInApiConsole")
  private Boolean showInApiConsole = null;

  @SerializedName("endpoints")
  private EnvironmentEndpoints endpoints = null;

  public Environment name(String name) {
    this.name = name;
    return this;
  }

   /**
   * Get name
   * @return name
  **/
  @ApiModelProperty(example = "Production and Sandbox", required = true, value = "")
  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Environment type(String type) {
    this.type = type;
    return this;
  }

   /**
   * Get type
   * @return type
  **/
  @ApiModelProperty(example = "hybrid", required = true, value = "")
  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public Environment serverUrl(String serverUrl) {
    this.serverUrl = serverUrl;
    return this;
  }

   /**
   * Get serverUrl
   * @return serverUrl
  **/
  @ApiModelProperty(example = "https://localhost:9443//services/", required = true, value = "")
  public String getServerUrl() {
    return serverUrl;
  }

  public void setServerUrl(String serverUrl) {
    this.serverUrl = serverUrl;
  }

  public Environment showInApiConsole(Boolean showInApiConsole) {
    this.showInApiConsole = showInApiConsole;
    return this;
  }

   /**
   * Get showInApiConsole
   * @return showInApiConsole
  **/
  @ApiModelProperty(example = "true", required = true, value = "")
  public Boolean getShowInApiConsole() {
    return showInApiConsole;
  }

  public void setShowInApiConsole(Boolean showInApiConsole) {
    this.showInApiConsole = showInApiConsole;
  }

  public Environment endpoints(EnvironmentEndpoints endpoints) {
    this.endpoints = endpoints;
    return this;
  }

   /**
   * Get endpoints
   * @return endpoints
  **/
  @ApiModelProperty(example = "null", required = true, value = "")
  public EnvironmentEndpoints getEndpoints() {
    return endpoints;
  }

  public void setEndpoints(EnvironmentEndpoints endpoints) {
    this.endpoints = endpoints;
  }


  @Override
  public boolean equals(java.lang.Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    Environment environment = (Environment) o;
    return Objects.equals(this.name, environment.name) &&
        Objects.equals(this.type, environment.type) &&
        Objects.equals(this.serverUrl, environment.serverUrl) &&
        Objects.equals(this.showInApiConsole, environment.showInApiConsole) &&
        Objects.equals(this.endpoints, environment.endpoints);
  }

  @Override
  public int hashCode() {
    return Objects.hash(name, type, serverUrl, showInApiConsole, endpoints);
  }


  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class Environment {\n");
    
    sb.append("    name: ").append(toIndentedString(name)).append("\n");
    sb.append("    type: ").append(toIndentedString(type)).append("\n");
    sb.append("    serverUrl: ").append(toIndentedString(serverUrl)).append("\n");
    sb.append("    showInApiConsole: ").append(toIndentedString(showInApiConsole)).append("\n");
    sb.append("    endpoints: ").append(toIndentedString(endpoints)).append("\n");
    sb.append("}");
    return sb.toString();
  }

  /**
   * Convert the given object to string with each line indented by 4 spaces
   * (except the first line).
   */
  private String toIndentedString(java.lang.Object o) {
    if (o == null) {
      return "null";
    }
    return o.toString().replace("\n", "\n    ");
  }
  
}

