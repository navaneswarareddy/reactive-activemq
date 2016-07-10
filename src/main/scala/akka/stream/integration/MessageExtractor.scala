/*
 * Copyright 2016 Dennis Vriend
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

package akka.stream
package integration

import akka.camel.CamelMessage
import spray.json.JsonReader

trait MessageExtractor[IN, OUT] {
  def extract(in: IN): OUT
}

trait JsonMessageExtractor {
  implicit def jsonMessageExtractor[A: JsonReader] = new MessageExtractor[CamelMessage, A] {
    import spray.json._
    override def extract(in: CamelMessage): A = {
      val jsonStr = in.body.asInstanceOf[String]
      jsonStr.parseJson.convertTo[A]
    }
  }
}

object JsonMessageExtractor extends JsonMessageExtractor